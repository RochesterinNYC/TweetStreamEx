# Use local alias
$ = jQuery

# Namespacing
window.TweetStreamPasswordReset ||= {}

TweetStreamPasswordReset.submit = () ->
  for el in $('.required_field')
    el = $(el)
    el.css({border: '1px solid #b4b4b4'})
  $('.errorlist').hide()
  $('#form_errors').html('')
  valid = TweetStreamPasswordReset.validate()
  if valid
    TweetStreamPasswordReset.hideError()
    TweetStreamPasswordReset.submit()
  else
    TweetStreamPasswordReset.showError()

TweetStreamPasswordReset.showError = () ->
  $('#user-message-success').hide()
  $('#user-message-error').show()

TweetStreamPasswordReset.hideError = () ->
  $('.errorlist').hide()
  $('#user-message-error').hide()
  $('#user-message-success').show()

TweetStreamPasswordReset.checkEmail = (email) ->
  error_free = true
  if email is ''
    error_free = false
    $('#email').css({border: '1px solid #c94435'})
    $('#email_errorlist').show()
  error_free

TweetStreamPasswordReset.validate = (fields) ->
  fields = $('input.required_field') unless fields
  error_free = true
  #error_free = TweetStreamPasswordReset.checkAccountEmail($('#email').attr('value'))
  for el in fields
    el = $(el)
    if ($.trim(el.val()).length is 0) or (el.attr('data_default_value') and $.trim(el.val()) is el.attr('data_default_value')) or (el.attr('value') == '')
      error_free = false
      error_list_el = $('#'+el.attr('id')+'_errorlist')
      el.css({border: '1px solid #c94435'})
      error_list_el.show()
  error_free

TweetStreamPasswordReset.submit = () ->
  formData = {
    'email': $('#email').val(),
  }
  url = document.location.protocol + "//" + document.location.host + "/reset/generate"
  params = { url: url, data: formData, type: 'POST', timeout: 5000, error: TweetStreamPasswordReset.validateError, statusCode: { 401: TweetStreamPasswordReset.validateError, 406: TweetStreamPasswordReset.validateError, 200: TweetStreamPasswordReset.validateSuccess }}
  # params.dataType = 'jsonp' if JSONP # use JSONP for development
  $.ajax(params)

TweetStreamPasswordReset.validateError = (data) ->
  TweetStreamPasswordReset.showError()

TweetStreamPasswordReset.validateSuccess = (data) ->
  if data.status is 'success'
    document.location.href = document.location.protocol + "//" + document.location.host + '/reset/forgot?success=1'
  else if (data.status is 'error')
    TweetStreamPasswordReset.showError()

TweetStreamPasswordReset.resetPassword = () ->
  for el in $('.required_field')
    el = $(el)
    el.css({border: '1px solid #b4b4b4'})
  $('.errorlist').hide()
  $('#form_errors').html('')
  valid = true
  if valid
    TweetStreamPasswordReset.hideError()
    TweetStreamPasswordReset.submitReset()
  else
    TweetStreamPasswordReset.showError()

TweetStreamPasswordReset.submitReset = () ->
  formData = {
    'id': $('#id').val(),
    'password': $('#password').val()
  }
  url = document.location.protocol + "//" + document.location.host + "/reset/password"
  params = { url: url, data: formData, type: 'POST', timeout: 5000, error: TweetStreamPasswordReset.validateError, statusCode: { 401: TweetStreamPasswordReset.validateError, 406: TweetStreamPasswordReset.validateError, 200: TweetStreamPasswordReset.validatePasswordReset }}
  # params.dataType = 'jsonp' if JSONP # use JSONP for development
  $.ajax(params)

TweetStreamPasswordReset.validatePasswordReset = (data) ->
  if data.status is 'success'
    document.location.href = document.location.protocol + "//" + document.location.host + '/login?reset=1'
  else if (data.status is 'error')
    TweetStreamPasswordReset.showError()
