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
  $('.datepicker').datepicker
    dateFormat: 'dd/mm/yyyy'

  $('form.readonly :input').attr 'readonly', true

  $('.datatable').dataTable
    sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
    sPaginationType: "bootstrap"
    aoColumnDefs: [
      { bVisible: false, bSearchable: true, aTargets: [0] }
    ]

  $('.datatable tbody tr').on 'click', ->
    id = $(this).attr('id').replace 'book_', ''
    window.location = "/books/#{id}"
