require 'stream_api'
class StreamController < ApplicationController
  @@stream = ::TweetStreamAPI.new
  # GET /stream/index
  def index
#    @query = Query.new 
    params.each do |key,value|
      puts "Param #{key}: #{value}"
    end

    #this feature work
    @tweets = @@stream.get_tweets params[:term0], params[:term1], params[:nterm0], params[:nterm1]
    #@tweets = @@stream.get_tweets 'apple', 'pie', 'ipad', 'new'    
  end
end
