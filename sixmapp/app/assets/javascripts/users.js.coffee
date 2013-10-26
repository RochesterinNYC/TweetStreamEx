# Use local alias
$ = jQuery

# Namespacing
window.TweetStreamUser ||= {}

TweetStreamUser.submit = () ->
  for el in $('.required_field')
    el = $(el)
    el.css({border: '1px solid #b4b4b4'})
  $('.errorlist').hide()
  $('#form_errors').html('')
  valid = TweetStreamUser.validate()
  sufficient_password = TweetStreamUser.sufficientPassword()
  if valid && sufficient_password
    TweetStreamUser.hideError()
    TweetStreamUser.register()
  else
    TweetStreamUser.showError()

TweetStreamUser.showError()
  $('#user-messages-success').hide()
  $('#user-messages-error').show()

TweetStreamUser.hideError = () ->
  $('.errorlist').hide()
  $('#user-messages-error').hide()
  $('#user-messages-success').show()

TweetStreamUser.sufficientPassword = () ->
  $('#password_errorlist').hide()
  if $('#password').val().length < 8 || 
    $('#id_password_errorlist').show()
    false
  else
    true

TweetStreamUser.validate = (fields) ->
  fields = $('input.required_field') unless fields
  error_free = true
  error_free = TweetStreamUser.checkAccountEmail($('#email').attr('value'))
  for el in fields
    el = $(el)
    if ($.trim(el.val()).length is 0) or (el.attr('data_default_value') and $.trim(el.val()) is el.attr('data_default_value')) or (el.attr('value') == '')
      error_free = false
      error_list_el = $('#'+el.attr('id')+'_errorlist')
      el.css({border: '1px solid #c94435'})
      error_list_el.show()
  error_free
