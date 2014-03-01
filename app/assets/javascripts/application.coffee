#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require jquery.turbolinks
#= require bootstrap
#= require jquery.ui.datepicker
#= require dataTables/jquery.dataTables
#= require dataTables/jquery.dataTables.bootstrap
#= require_tree .

$ ->
  $('form.readonly :input').attr 'readonly', true

  $('.datepicker:not([readonly])').datepicker
    dateFormat: 'dd/mm/yy'

  $('.datatable').dataTable
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sPaginationType: "bootstrap"
    aoColumnDefs: [
      { bVisible: false, bSearchable: true, aTargets: [0] }
    ]

  $(document).delegate '.datatable tbody tr', 'click', ->
    id = $(this).attr('id').replace 'book_', ''
    window.location = "/books/#{id}"

  $(document).delegate '#book_isbn', 'keyup', -> check_isbn_length()
  $(document).delegate '#book_isbn', 'mousedown', -> check_isbn_length()

  $(document).delegate '#lookup-isbn', 'click', ->
    $('#not-found').hide()
    button = $(this)
    unless button.hasClass('disabled')
      button.addClass('disabled')
      $.getJSON("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn()}", (data) ->
        if data.totalItems > 0 and info = data.items[0].volumeInfo
          $('#book_title').val info.title
          $('#book_author').val info.authors.join(',')
          $('#book_publisher').val info.publisher
          $('#book_edition').val info.publishedDate
          $('#book_thumbnail').val info.imageLinks.thumbnail
          $('img').attr 'src', info.imageLinks.thumbnail
          $('img').show()
          $('#book_description').val info.description
        else
          not_found()
      ).fail(->
        not_found()
      ).always ->
        button.removeClass('disabled')

  isbn = -> $('#book_isbn').val().replace(/\D/g, '')

  check_isbn_length = ->
    $('#not-found').hide()
    if isbn().length == 10 or isbn().length == 13
      $('#lookup-isbn').show()
    else
      $('#lookup-isbn').hide()

  not_found = (message) ->
    message ||= 'Not found'
    $('input:not(#book_isbn):not(.btn), textarea').val('')
    $('#not-found').val(message)
    $('#not-found').show()
    $('img').hide()

  $('#new_contact').bind 'ajax:success', ->
    $('#contact_seller').modal 'hide'
    alert "We're sending the seller an email on your behalf now!"

  $('#new_contact').bind 'ajax:error', (_, data)->
    message = "Sorry, but we couldn't submit your request.\n"
    try
      message += "There were problems with the data you entered:\n"
      for field, errors of $.parseJSON(data.responseText).errors
        message += "#{field.replace('_',' ')}: #{errors.join ', '}\n"
    catch err
      message += "Please reload the page and try again"
    alert message
