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

TweetStreamUser.showError = () ->
  $('#user-message-success').hide()
  $('#user-message-error').show()

TweetStreamUser.hideError = () ->
  $('.errorlist').hide()
  $('#user-message-error').hide()
  $('#user-message-success').show()

TweetStreamUser.sufficientPassword = () ->
  $('#password_errorlist').hide()
  if $('#password').val().length < 8
    $('#password_errorlist').show()
    false
  else
    true

TweetStreamUser.checkAccountEmail = (email) ->
  error_free = true
  if email is ''
    error_free = false
    $('#email').css({border: '1px solid #c94435'})
    $('#email_errorlist').show()
  else if !/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$/i.test($.trim(email))
    error_free = false    
    $('#email').css({border: '1px solid #c94435'})
    $('#email_errorlist').show()
  error_free

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
