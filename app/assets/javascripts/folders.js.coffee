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

  # Slides the element creation forms up and down
  $('header').on 'click', '.add_file a, #add_folder a', ->
    li = $(this).parent().next()
    if $(li).css('display') == 'list-item'
      $(li).slideUp('fast')
    else
      $(li).slideDown('fast')

  # Shows the selected files bar
  $('.elements_nav').on 'click', '.show_folder', ->
    $('#current_folder').attr('id', '') if $('#current_folder') != undefined
    $('.show_folder').prev().css('display', 'none')
    $(this).prev().css('display', 'inline-block')
    $(this).parent().attr('id', 'current_folder')
    $('.files_bar').css('z-index', '1')
    $('#folder_' + $(this).attr('id').split('_')[1]).css('z-index', '4')

  # Edit element form
  $('.elements_nav').on 'click', '.edit_element', ->
    $(this).prev().prev().hide()
    $(this).prev('.rename_element').show()
  $('#current_record').on 'click', '.edit_element', ->
    $(this).prev().prev().hide()
    $(this).prev('.rename_element').show()

  # Custom scrollbars
  $(".fancy_scroll").jScrollPane
    horizontalGutter: 5
    verticalGutter: 5
    showArrows: false

  $(".jspDrag").hide()

  $(".jspScrollable").mouseenter ->
    $(this).find(".jspDrag").stop(true, true).fadeIn "slow"

  $(".jspScrollable").mouseleave ->
    $(this).find(".jspDrag").stop(true, true).fadeOut "slow"