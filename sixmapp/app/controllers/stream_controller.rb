require 'stream_api'
class StreamController < ApplicationController
  @@stream = ::TweetStreamAPI.new
  # GET /stream/index
  def index
#    @query = Query.new 
    params.each do |key,value|
      puts "Param #{key}: #{value}"
    end

    #Language is set to English for now
    #Only term0 works for now
    @tweets = @@stream.get_tweets params[:keywords], params[:exclude], params[:language], params[:latitude], params[:longitude], params[:radius], params[:distance]
    #@tweets = @@stream.get_tweets 'apple'    
  end

  def search
    @query = params[:query] 
    @num_tweets = params[:numTweets]
    @tweets = @@stream.get_tweets @query, '', nil, nil, nil, nil, nil 
    @tweet_jsons = Array.new(@num_tweets.to_i)
    (0..(@num_tweets.to_i - 1)).each do |i|
      @tweet_jsons[i] = @@stream.jsonify_tweet(@tweets[i])
    end
    render json: {tweets: @tweet_jsons}
  end

  def test

  end
end
