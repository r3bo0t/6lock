# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.delete_element').bind 'ajax:success', ->
    $(this).parent().remove()
  # Shows and hides the cross
  $('.elements_nav .element_link').hover(
    -> $('a:first-child', this).css('display', 'inline-block') if $(this).attr('id') != 'current_folder' && $(this).attr('id') != 'current_record'
    -> $('a:first-child', this).css('display', 'none') if $(this).attr('id') != 'current_folder' && $(this).attr('id') != 'current_record'
  )
  # Slides the folder creation form up and down
  $('#add_folder a').click(
    ->
      if $('#add_folder_form').css('display') == 'list-item'
        $('#add_folder_form').slideUp('fast')
      else
        $('#add_folder_form').slideDown('fast')
  )
  # Slides the file creation form up and down
  $('.existing_files_bar .add_file a').click(
    ->
      if $(this).parent().next().css('display') == 'list-item'
        $(this).parent().next().slideUp('fast')
      else
        $(this).parent().next().slideDown('fast')
  )
  # Shows the selected files bar
  $('.show_folder').click(
    ->
      $('#current_folder').attr('id', '') if $('#current_folder') != undefined
      $('.show_folder').prev().css('display', 'none')
      $(this).prev().css('display', 'inline-block')
      $(this).parent().attr('id', 'current_folder')
      $('.files_bar').css('z-index', '1')
      $('#folder_' + $(this).attr('id').split('_')[1]).css('z-index', '4')
  )
  # Edit element form
  $('.edit_element').click(
    ->
      $(this).prev().prev().hide()
      $(this).prev('.rename_element').show()
  )
