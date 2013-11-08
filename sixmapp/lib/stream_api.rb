require 'twitter'

class TweetStreamAPI

  # These are the twitter credentials for the app registered
  # with 1337scriptdaddy@gmail.com
  @@tweet_array = Array.new

  Twitter.configure do |config|
    config.consumer_key       = 'hIl8qNe1VqxKJuxHhWoA'
    config.consumer_secret    = 'iQxdv9Ak6T9fM8DtvdGAdGZGDqfvyiTiCXbPaXI0U8Y'
    config.oauth_token        = '1944743442-3pV23TQz68mT0GeyoINA6HDwRoe78UvWwLRLWuY'
    config.oauth_token_secret = 'w6hMGXVwNKCjL60jhEDXJs1nzhMP0r5Rmsxoa7wSRc'
  #  config.auth_method        = :oauth
  end 

  #Search tweets matching search terms and return them
  def get_tweets term0, term1, lang
    puts "********"
    puts term0
    puts "********"
    search_results = Array.new
    if( (term0 == nil and term1 == nil) or (term0 == "" and term1 == "") )
      return search_results # will be blank
    end
    puts ""
    puts "------------------------------------------------------------"
    Twitter.search(term0, :count => 10, :result_type => "recent").results.map do |status|
     
      # Come up with more efficient implementation of case-insensitive string match
      if (status.lang == lang and (verify_terms term0, status))
         mark_terms term0, status
         @@tweet_array.unshift status
         puts "#{status.created_at} #{status.user.location} #{status.id} #{status.lang}"
         puts  "#{status.user.id} #{status.from_user}: #{status.text}"
         puts "------------------------------------------------------------"
         puts ""
      end
    end
    return @@tweet_array
  end

  #Verifying that tweets returned by Twitter Search API actually include the search terms
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

  @@term0 = ""
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
      TweetStream::Client.new.track(@@term0, @@term1) do |status, client|
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

  @@term0_old = ""
  @@term1_old = ""
  @@nterm0_old = ""
  @@nterm1_old = ""
  @@nothing = Array.new
  def get_tweets term0, term1, nterm0, nterm1
    start_th if @@first_wakeup

    puts "term0 == #{term0 == nil}"; puts "term1 == #{term1 ==nil}"
    # case 1: blank terms
    if( (term0 == nil and term1 == nil) or (term0 == "" and term1 == "") )
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
      @@term0_old = term0
      @@term1_old = term1
      @@term0 = term0
      @@term1 = term1

      @@mutex.synchronize {return @@tweet_array}


    # case 2: different from last time
    elsif ( term0 != @@term0_old or term1 != @@term1_old )
      puts "<><><><><><><>><><><> NEW TERMS <><><><><><><><><><><><><"
      @@term0_old = term0
      @@term1_old = term1
      @@term0 = term0
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