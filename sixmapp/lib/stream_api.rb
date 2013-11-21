require 'twitter'

class TweetStreamAPI

  # These are the twitter credentials for the app registered
  # with 1337scriptdaddy@gmail.com
  @@tweet_array = Array.new
  @@keywords = ""
  @@term1 = ""

  Twitter.configure do |config|
    config.consumer_key       = 'hIl8qNe1VqxKJuxHhWoA'
    config.consumer_secret    = 'iQxdv9Ak6T9fM8DtvdGAdGZGDqfvyiTiCXbPaXI0U8Y'
    config.oauth_token        = '1944743442-3pV23TQz68mT0GeyoINA6HDwRoe78UvWwLRLWuY'
    config.oauth_token_secret = 'w6hMGXVwNKCjL60jhEDXJs1nzhMP0r5Rmsxoa7wSRc'
  #  config.auth_method        = :oauth
  end 

  #Search tweets matching search terms and return them
  def get_tweets keywords, excluded, language, latitude, longitude, radius, distance
    if (keywords == nil  or keywords == "")
      return Array.new # return an empty array if search terms are empty
    end
    #if search terms changed
    if (@@keywords != keywords)
      @@keywords = keywords
      @@tweet_array = Array.new #reset array
    end
    Twitter.search(keywords, :lang => language, :count => 10, :result_type => "recent",
            :geocode => "#{latitude},#{longitude},#{radius}#{distance}").results.reverse.map do |status|
    
      if ((verify_terms keywords, status) and not (already_exist status) and not (contains_excluded_terms excluded, status))
         mark_terms keywords, status
         @@tweet_array.push status
         puts  "#{status.user.id} #{status.from_user}: #{status.text}"
         #puts "#{status.created_at} #{status.user.location} #{status.id} #{status.lang}"
         #puts  "#{status.user.id} #{status.from_user}: #{status.text}"
         #puts "------------------------------------------------------------"
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

end










=begin

  @@keywords = ""
  @@term1 = ""
  @@first_wakeup = true
  @@stop = false
  @@reset_terms = false
  
  def start_th
  @@stream_th = Thread.new do
    while true 
      puts "!!!!!!!!!!!!! SLEEPING !!!!!!!!!!!!!!"
      Thread.stop if @@first_wakeup
      puts "!!!!!!!!!!!!! WAKEUP !!!!!!!!!!!!!!!"
      @@first_wakeup = false
      TweetStream::Client.new.track(@@keywords, @@term1) do |status, client|
        break_flag = false
        if @@stop
          client.stop
          puts "<<<<<<<<<<<<<<< STOP >>>>>>>>>>>>>>>>>"
          @@stop = false
          Thread.stop
          break_flag = true
        end
        break if break_flag
        if @@reset_terms
          client.stop
          puts "<<<<<<<<<<<<<<< RESET >>>>>>>>>>>>>>>>>"
          @@reset_terms = false
          Thread.stop
          puts "############## RESTART ################"
          break_flag = true
        end
      
        break if break_flag
        puts status.text
        @@mutex.synchronize {@@tweet_array.push status.text}
      end
      puts "##### BROKE EEEEE"
    end
  end
  end
  

  # note that the thread is started and stopped every time 
  # this function is called. This is not ideal, since the
  # user won't update the search terms often. Works for now...

  @@keywords_old = ""
  @@term1_old = ""
  @@nkeywords_old = ""
  @@nterm1_old = ""
  @@nothing = Array.new
  def get_tweets keywords, term1, nkeywords, nterm1
    start_th if @@first_wakeup

    puts "keywords == #{keywords == nil}"; puts "term1 == #{term1 ==nil}"
    # case 1: blank terms
    if( (keywords == nil and term1 == nil) or (keywords == "" and term1 == "") )
      puts "!!!!!!! nothing !!!!!!!"
      unless @@first_wakeup
        @@stream_th.terminate
        while(@@stream_th.alive?)
          puts "die! die! die!"
        end   
      end
      return @@nothing
    elsif ( @@first_wakeup )
      
      @@stream_th.wakeup
      @@keywords_old = keywords
      @@term1_old = term1
      @@keywords = keywords
      @@term1 = term1

      @@mutex.synchronize {return @@tweet_array}


    # case 2: different from last time
    elsif ( keywords != @@keywords_old or term1 != @@term1_old )
      puts "<><><><><><><>><><><> NEW TERMS <><><><><><><><><><><><><"
      @@keywords_old = keywords
      @@term1_old = term1
      @@keywords = keywords
      @@term1 = term1

      @@stream_th.terminate
      while(@@stream_th.alive?)
        puts "die! die! die!"
      end
          

      start_th
      
      @@mutex.synchronize {return @@tweet_array}
    
    # case 3: same terms as last time
    else
      puts " >>>>>>>>>>>>>> NOTHING NEW <<<<<<<<<<<<<<<<<<<"
      @@mutex.synchronize {return @@tweet_array}
    end

    # case 3: same terms as last time

    # case 4: new set of valid terms

  end

end

=end