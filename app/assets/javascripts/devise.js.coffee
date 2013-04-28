$ ->
  $('#sign_up_button').click (e) ->
    unless $('#agreement').is ':checked'
      e.preventDefault()
      alert('You have to check the checkbox in order for us to know you understand our terms')