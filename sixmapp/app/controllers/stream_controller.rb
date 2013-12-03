require 'stream_api'
class StreamController < ApplicationController
  @@stream = ::TweetStreamAPI.new
  @@session_array = ['Time', 'Num of Tweets']
  @@start_time
  @@graph_time
  @@first_time = true
  # GET /stream/index

  def index

  end

  #nil parameters result if the parameters weren't
  #in the URL. Otherwise, it is a zero length string
  def search
    @warning

    #people can hardwire as many bogus params in the
    #URL as they want. If there are a zillion of them
    #we will have a denial of service iterating over
    #and array of 5 million....    
    #we shouldn't allow more than we need we need to 
    #check this first before we start doing loops on 
    #the array
    if params.size > 11
      puts "SOMETHING IS UP"
      @warning = "please click search and try again"
    end

    defaults = {:keywords => "", :exclude => "", :language=> "en", :latitude=> "", :longitude=> "", :radius=> "", :distance=> ""}
    params.replace(defaults.merge(params))

    #for debugging
    params.each do |key,value|
      puts "Param #{key}: #{value} #{value.length}"
    end

    #is it just me or should this sanitizing code go somewhere else?
    # - Jeffrey Scholz
    if params[:keywords].length > 255
      @warning = "input too long!"
    end

    if params[:exclude].length > 255
      @warning = "input too long!"
    end

    if (params[:language] != "en" and params[:language] != "es")
       @warning = "invalid language"
    end

    if params[:distance] != "mi" and params[:distance] != "km"
       @warning = "invalid distance units"
    end

    #latitude goes from -90 to 90 and longitude from -180 to 180
    #we use a regex to make sure the input is a decimal number
    #and then float comparision to make sure that decimal is in range
    #trying to constrain a signed decimal number to a valid range with
    #a regex would be really complicated
    unless /(^[-]?([\d]?[\d]?)(\.|$|\.$)[\d]{0,20}$|^$)/.match params[:latitude]
      @warning = "hmm... that latitude won't work"
    end
    if params[:latitude].to_f > 90 or params[:latitude].to_f < -90
      @warning = "latitude is out of range"
    end

    unless /(^[-]?[\d]?[\d]?[\d]?(\.|$|\.$)[\d]{0,20}$|^$)/.match params[:longitude]
      @warning = "hmm... that longitude won't work"
    end
    if params[:longitude].to_f > 180 or params[:longitude].to_f < -180
      @warning = "longitude is out of range"
    end

    #same thing with the distance, security feature, not useability
    #check. let twitter do the tough legwork
    unless /(^[\d]{0,20}[.]?{0,20}$|^$)/.match params[:radius]
      @warning = "that's not a valid radius"
    end

    #unless /(^[\d]{0,20}[.]?{0,20}$|^$)/.match params[:distance]
    #  @warning = "that's not a valid distance"
    #end

    puts "!!!!!!!!!!!!!!"
    puts @@session_array
    puts "!!!!!!!!!!!!!!"
    #update startime

    if @@first_time
       @@start_time = Time.now.to_f.to_i
       @@graph_time = 0
    else
      @@graph_time = Time.now.to_f.to_i - @@start_time
    end

    @@first_time = false


    unless @warning
      @tweets = @@stream.get_tweets params[:keywords], params[:exclude],
				    params[:language], params[:latitude], 
                                    params[:longitude], params[:radius], 
                                    params[:distance]
      @@session_array.push [@@graph_time,@tweets.size] 
    else
      @tweets = Array.new
      @@session_array.push [@@graph_time,@tweets.size]
    end

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
    @keywords, @exclude, @language, @latitude, @longitude, @radius, @distance = *params.values_at(:keywords, :exclude, :language, :latitude, :longitude, :radius, :distance)
  end 

end
