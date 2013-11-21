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
    @tweets = @@stream.get_tweets params[:keywords], params[:exclude], params[:language],
            params[:latitude], params[:longitude], params[:radius], params[:distance]
    #@tweets = @@stream.get_tweets 'apple'    
  end

  def test
  
  end
end
