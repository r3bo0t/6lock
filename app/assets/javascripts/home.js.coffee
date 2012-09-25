# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#folders_nav li:nth-child(n+2)').hover(
    -> $('a:first-child', this).css('display', 'inline-block')
    -> $('a:first-child', this).css('display', 'none')
  )
