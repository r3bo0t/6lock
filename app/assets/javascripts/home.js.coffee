$ ->
  editions = 0
  a = ['Edit', 'Done']
  $('#edit_favorites').click ->
    $(this).html(a[++editions%2])
    $('.delete_favorite').slideToggle(250)
    $('.change_favorite').slideToggle(250)