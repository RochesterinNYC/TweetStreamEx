require 'stream_api'
class StreamController < ApplicationController
  @@stream = ::TweetStreamAPI.new
  # GET /stream/index


  #nil parameters result if the parameters weren't
  #in the URL. Otherwise, it is a zero length string
  def index
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

    #latitude goes from -90 to 90 and longitude from -180 to 180
    #checking decimal numbers in a range a regex is a pain, so we'll
    #let twitter deal with that. We won't check boundary conditions
    #but we will make sure they only enter a digit with something
    #reasonable before and after the decimal place. This is a security
    #feature, not a gps validator
    unless /(^[-]?([\d]?[\d]?)(\.|$|\.$)[\d]{0,20}$|^$)/.match params[:latitude]
      @warning = "hmm... that latitude won't work"
    end

    unless /(^[-]?[\d]?[\d]?[\d]?(\.|$|\.$)[\d]{0,20}$|^$)/.match params[:longitude]
      @warning = "hmm... that longitude won't work"
    end

    #same thing with the distance, security feature, not useability
    #check. let twitter do the tough legwork
    unless /(^[\d]{0,20}[.]?{0,20}$|^$)/.match params[:radius]
      @warning = "that's not a valid radius"
    end

    #unless /(^[\d]{0,20}[.]?{0,20}$|^$)/.match params[:distance]
    #  @warning = "that's not a valid distance"
    #end

    unless @warning
      @tweets = @@stream.get_tweets params[:keywords], params[:exclude],
				    params[:language], params[:latitude], 
                                    params[:longitude], params[:radius], 
                                    params[:distance]
    else
      @tweets = Array.new
    end
  end

  def test
  
  end
end
