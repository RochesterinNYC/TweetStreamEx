# Use local alias
$ = jQuery

# Namespacing
window.TweetStreamUI ||= {}
window.TweetArray = []
window.TweetStorage = []

TweetStreamUI.refresh = () ->
  TweetStreamUI.refreshTweetArray()
  TweetStreamUI.renderTweets()

TweetStreamUI.refreshTweetArray = () ->
  #Remove the two last tweets (oldest) of array
  TweetArray.pop()
  TweetArray.pop()
  #Add two tweets from storage to front of array
  TweetArray.unshift(TweetStorage.shift())
  TweetArray.unshift(TweetStorage.shift())

TweetStreamUI.renderTweets = () ->
  for tweet, x in TweetArray
    TweetStreamUI.renderTweet(x)

TweetStreamUI.renderTweet = (index) ->
  $('#tweet' + index + 'text').innerHTML = TweetArray[index]["text"]
  $('#tweet' + index + 'name').innerHTML = TweetArray[index]["name"]
  $('#tweet' + index + 'handle').innerHTML = TweetArray[index]["handle"]
  $('#tweet' + index + 'url').attr("href", TweetArray[index]["url"])
  $('#tweet' + index + 'date').innerHTML = TweetArray[index]["date"]

TweetStreamUI.getTweets = () ->
  formData = {
    #'query': $('#query').val(),
    #'numTweets': $('#numTweets').val()
    'query': "cats",
    'numTweets': 10
  }
  url = document.location.protocol + "//" + document.location.host + "/stream/search"
  params = { url: url, data: formData, type: 'GET', timeout: 5000, error: TweetStreamUI.validateError, statusCode: { 401: TweetStreamUI.validateError, 406: TweetStreamUI.validateError, 200: TweetStreamUI.validateSuccess }}
  # params.dataType = 'jsonp' if JSONP # use JSONP for development
  $.ajax(params)

TweetStreamUI.validateError = (data) ->
  alert("Error occurred.")
  #TweetStreamUI.showError()

TweetStreamUI.validateSuccess = (data) ->
  for tweet, x in TweetArray
    TweetStorage[x] = data.tweets[x]

