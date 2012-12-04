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
  # Forge a password
  $('#generate').click(
    ->
      characters_list = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
      numbers_list = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
      specials_list = ['#', '{', '(', '[', '-', '_', '\\', '@', ')', ']', '=', '}', '+', '*', '/', '.', ',', ';', '?', '!', '$']
      generated = ''
      array = []
      length = $('#length').val()
      characters = $('#characters').is(':checked')
      numbers = $('#numbers').is(':checked')
      specials = $('#specials').is(':checked')
      if length > 0 && length < 101
        if characters || numbers || specials
          array.push(characters_list) if characters
          array.push(numbers_list) if numbers
          array.push(specials_list) if specials
          for i in [0...length]
            select = array[Math.floor(Math.random() * array.length)]
            value = select[Math.floor(Math.random() * select.length)]
            value = value.toUpperCase() if select = characters_list && [true, false][Math.floor(Math.random() * 2)]
            generated += value
          $('#generated').val(generated)
        else
          alert('There must be characters, numbers or specials')
      else
        alert('The length must be between 1 and 100')
  )
  $('#forge_button').click(
    ->
      $('#password_value').val($('#generated').val())
      $('#record_decrypted_password').val($('#generated').val())
      $('#overlay').hide()
      $('#overlay_box').hide()
  )