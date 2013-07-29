#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require jquery.ui.datepicker
#= require_tree .

$ ->
  $('.datepicker').datepicker
    dateFormat: 'dd/mm/yyyy'

  $('form.readonly :input').attr('readonly', true)
