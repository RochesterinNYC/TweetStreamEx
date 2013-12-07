require 'twitter'

class TweetStreamAPI

  #These are the twitter credentials for the app registered
  #with 1337scriptdaddy@gmail.com
  @@tweet_array = Array.new
  @@keywords = ""
  @@term1 = ""

  Twitter.configure do |config|
    config.consumer_key       = 'hIl8qNe1VqxKJuxHhWoA'
    config.consumer_secret    = 'iQxdv9Ak6T9fM8DtvdGAdGZGDqfvyiTiCXbPaXI0U8Y'
    config.oauth_token        = '1944743442-3pV23TQz68mT0GeyoINA6HDwRoe78UvWwLRLWuY'
    config.oauth_token_secret = 'w6hMGXVwNKCjL60jhEDXJs1nzhMP0r5Rmsxoa7wSRc'
  end 

  #Search tweets matching keywords but excluding forbidden words
  #matching language and location
  def get_tweets keywords, excluded, language, latitude, longitude, radius, distance

    #Return an empty array if search terms are empty
    if (nil_or_blank keywords)
      return Array.new 
    end

    #If search terms changed
    if (@@keywords != keywords)
      @@keywords = keywords

      #reset array
      @@tweet_array = Array.new 
    end

    #When any of the location parameters is blank
    #Search 10 most recent tweets using the Twitter API, first filtering by keywords
    if (nil_or_blank latitude or nil_or_blank longitude or nil_or_blank radius or nil_or_blank distance)
      Twitter.search(keywords, :lang => language, :count => 100, :result_type => "recent").results.reverse.map do |status|
      #Push tweet objects if keywords match, if they are not already pushed, and if they don't include
      #excluded terms
        if ((verify_terms keywords, status) and not (already_exist status) and not (contains_excluded_terms excluded, status))
           mark_terms keywords, status
           @@tweet_array.push status
        end
      end
    else
    #When location parameters are all present     
    #Search 10 most recent tweets using the Twitter API, first filtering by keywords, language and location
      Twitter.search(keywords, :lang => language, :count => 100, :result_type => "recent",
            :geocode => "#{latitude},#{longitude},#{radius}#{distance}").results.reverse.map do |status|
        if ((verify_terms keywords, status) and not (already_exist status) and not (contains_excluded_terms excluded, status))
           mark_terms keywords, status
           @@tweet_array.push status
        end
      end
    end
    return @@tweet_array
  end

  #Ensure that a tweet doesn't already exist in the tweet_array from previous search results
  def already_exist status
    @@tweet_array.each do |tweet|
      if (tweet.id == status.id)
        return true
      end
    end
    return false
  end

  #Verify that tweets returned by Twitter Search API actually include the search terms
  #Twitter Search API returns results it thinks are relevant but not include the search terms
  def verify_terms search_term, status
    split_terms = search_term.split(' ')
    split_terms.each do |term|
      unless status.text.downcase.include? term.downcase
        return false
      end
    end
    return true
  end

  #Helper function to determine whether tweet contains excluded word
  def contains_excluded_terms excluded, status
    split_terms = excluded.split(' ')
    split_terms.each do |term|
      if status.text.downcase.include? term.downcase
        #puts "#{status.text}"
        return true
      end
    end
    return false
  end

  #Highlight search terms in the statuses
  def mark_terms search_term, status
    split_terms = search_term.split(' ')
    split_terms.each do |term|
      unless term == nil or term == ""
        status.text.gsub! /#{term}/i, "<mark>#{term}</mark>"
      end
    end
  end

  #Helper function to check whether a term is nil or blank
  def nil_or_blank term
    (term.nil? or term.blank?) ? true : false
  end

  #Create JSON objects for front-end
  def jsonify_tweet status
    url = "https://twitter.com/#{status.user.handle}/statuses/#{status.id}"
    time = status.created_at.to_i
    Hash[text: status.text, name: status.user.name, handle: status.user.handle, url: url, time: time, image: status.user.profile_image_url]
  end

end


