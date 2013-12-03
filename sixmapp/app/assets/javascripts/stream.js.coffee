# Use local alias
$ = jQuery

# Namespacing
window.TweetStreamUI ||= {}
window.TweetArray = []
window.TweetStorage = []

TweetStreamUI.refresh = () ->
  TweetStreamUI.refreshTweetArray()
  TweetStreamUI.renderTweets()
  TweetStreamUI.renderBorders()

TweetStreamUI.refreshTweetArray = () ->
  #Remove the two last tweets (oldest) of array
  if(TweetArray.length == 10)
    TweetArray.pop()
    TweetArray.pop()
    #Add two tweets from storage to front of array
  TweetArray.unshift(TweetStorage.shift())
  TweetArray.unshift(TweetStorage.shift())
  #Initial TweetArray Fill
  #else
  #  for tweet, x in TweetStorage
  #    TweetArray[x] = TweetStorage[x]
  #  TweetStreamUI.getTweets()

TweetStreamUI.renderBorders = () ->
  if $('.border-active').length is 0
    current1 = 0
    current2 = 1
  else
    current1 = parseInt($('.border-active')[0].id.replace('tweet', '')) + 2
    current2 = parseInt($('.border-active')[1].id.replace('tweet', '')) + 2
    if current1 > 9 || current2 > 10
      current1 = 0
      current2 = 1
  for el in $('.tweet')
    el = $(el)
    el.css({border: '2px solid black'})
    el.removeClass('border-active')
  $('#tweet' + current1).css({border: '2px solid #55ACEE'})
  $('#tweet' + current1).addClass('border-active')
  $('#tweet' + current2).css({border: '2px solid #55ACEE'})
  $('#tweet' + current2).addClass('border-active')

TweetStreamUI.renderTweets = () ->
  for tweet, x in TweetArray
    TweetStreamUI.renderTweet(x)

TweetStreamUI.renderTweet = (index) ->
  $('#tweet' + index + 'image').attr("src", TweetArray[index]["image"])
  $('#tweet' + index + 'name').html(TweetArray[index]["name"])
  $('#tweet' + index + 'handle').html("@" + TweetArray[index]["handle"])
  $('#tweet' + index + 'text').html(TweetArray[index]["text"])
  $('#tweet' + index + 'time').html(TweetStreamUI.getTime(TweetArray[index]["time"]) + " seconds ago")
  $('#tweet' + index).attr("href", TweetArray[index]["url"])
  if $('#tweet' + index).hasClass("tweet-inactive") and $('#tweet' + index + 'handle').text().length != 0
    $('#tweet' + index).toggleClass("tweet-inactive tweet-active")

TweetStreamUI.getTime = (time) ->
  return Math.ceil((new Date().getTime()/1000)) - time

TweetStreamUI.getTweets = () ->
  #window.TweetArray = []
  formData = {
    'keywords': $('#tweet_keywords').val(),
    'exclude': $('#tweet_exclude').val(),
    'language': $('#tweet_language').val(),
    'latitude': $('#tweet_latitude').val(),
    'longitude': $('#tweet_longitude').val(),
    'radius': $('#tweet_radius').val(),
    'distance': $('#tweet_distance').val(),
    'numTweets': $('#tweet_numTweets').val()
  }
  url = document.location.protocol + "//" + document.location.host + "/search"
  params = { url: url, data: formData, type: 'GET', timeout: 5000, error: TweetStreamUI.validateError, statusCode: { 401: TweetStreamUI.validateError, 406: TweetStreamUI.validateError, 200: TweetStreamUI.validateSuccess }}
  # params.dataType = 'jsonp' if JSONP # use JSONP for development
  $.ajax(params)

TweetStreamUI.validateError = (data) ->
  #TweetStreamUI.showError()

TweetStreamUI.validateSuccess = (data) ->
  for tweet, x in data.tweets
    TweetStorage[x] = data.tweets[x]
  $('#number-tweets').html(data.num_tweets)
