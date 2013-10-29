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
  password_match = TweetStreamUser.passwordMatch()
  if valid && sufficient_password && password_match
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
    $('#password').css({border: '1px solid #c94435'})
    false
  else
    true

TweetStreamUser.passwordMatch = () ->
  $('#password_confirmation_errorlist').hide()
  passwordMatch = true
  if $('#password').val() != $('#password_confirmation').val()
    passwordMatch = false
    $('#password_confirmation_errorlist').show()
    $('#password_confirmation').css({border: '1px solid #c94435'})
  passwordMatch

TweetStreamUser.checkEmail = (email) ->
  error_free = true
  if email is ''
    error_free = false
    $('#email').css({border: '1px solid #c94435'})
    $('#email_errorlist').show()
  error_free

TweetStreamUser.validate = (fields) ->
  fields = $('input.required_field') unless fields
  error_free = true
  error_free = TweetStreamUser.checkEmail($('#email').attr('value'))
  for el in fields
    el = $(el)
    if ($.trim(el.val()).length is 0) or (el.attr('data_default_value') and $.trim(el.val()) is el.attr('data_default_value')) or (el.attr('value') == '')
      error_free = false
      error_list_el = $('#'+el.attr('id')+'_errorlist')
      el.css({border: '1px solid #c94435'})
      error_list_el.show()
  error_free

TweetStreamUser.register = () ->
  formData = { 
    'first_name': $('#first_name').val(),
    'last_name': $('#last_name').val(),
    'email': $('#email').val(),
    'password': $('#password').val()
  }
  url = document.location.protocol + "//" + document.location.host + "/users/create"
  params = { url: url, data: formData, type: 'POST', timeout: 5000, error: TweetStreamUser.validateError, statusCode: { 401: TweetStreamUser.validateError, 406: TweetStreamUser.validateError, 200: TweetStreamUser.validateSuccess }}
  # params.dataType = 'jsonp' if JSONP # use JSONP for development
  $.ajax(params)

TweetStreamUser.validateError = (data) ->
  TweetStreamUser.showError()
  
TweetStreamUser.validateSuccess = (data) ->
  if data.status is 'success'
    document.location.href = document.location.protocol + "//" + document.location.host + '/users/new?success=1'
  else if (data.status is 'error')
    TweetStreamUser.showError()