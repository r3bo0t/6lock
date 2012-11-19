# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  # Shows and hides the cross
  $('.elements_nav .element_link').hover(
    -> $('a:first-child', this).css('display', 'inline-block')
    -> $('a:first-child', this).css('display', 'none')
  )
  # Slides the folder creation form up and down
  $('#add_folder a').click(
    ->
      if $('#add_folder_form').css('display') == 'list-item'
        $('#add_folder_form').slideUp('fast')
      else
        $('#add_folder_form').slideDown('fast')
  )
  $('.show_folder').click(
    ->
      $('#current_folder').attr('id', '') if $('#current_folder') != undefined
      $(this).parent().attr('id', 'current_folder')
      $('.files_bar').css('z-index', '1')
      $('#folder_' + $(this).attr('id').split('_')[1]).css('z-index', '4')
  )
