# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#folders_nav .folder_link').hover(
    -> $('a:first-child', this).css('display', 'inline-block')
    -> $('a:first-child', this).css('display', 'none')
  )
  $('#add_folder a').click(
    ->
      if $('#add_folder_form').css('display') == 'list-item'
        $('#add_folder_form').slideUp('fast')
      else
        $('#add_folder_form').slideDown('fast')
  )
