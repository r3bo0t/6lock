# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  # Shows or hides password
  $('#toggle').click(
    ->
      $('.info_password').toggle() if ($('.info_password') != undefined)
      $('.decrypted_password').toggle() if ($('.decrypted_password') != undefined)
  )
  # Fills both password fields
  $('.decrypted_password').keyup(
    ->
      $('.decrypted_password').val($(this).val())
  )
  # Forge button
  $('#forge').click(
    ->
      top = ($(window).height - $('#overlay_box').height) / 2
      left = ($(window).width - $('#overlay_box').width) / 2
      $('#overlay_box').css({top:top, left:left})
      $('#overlay').show()
      $('#overlay_box').show()
  )
  # Cancel forge
  $('#cancel_forge').click(
    ->
      $('#overlay').hide()
      $('#overlay_box').hide()
  )