$ ->
  editions = 0
  a = ['Edit', 'Done']
  $('#edit_favorites').click ->
    $(this).html(a[++editions%2])
    $('.delete_favorite').slideToggle(150)
    $('.change_favorite').slideToggle(150)

  $('.change_favorite select').change ->
    $(this).parent('form').submit()