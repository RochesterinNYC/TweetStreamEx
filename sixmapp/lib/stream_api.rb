require 'tweetstream'
require 'thread'

class TweetStreamAPI
  def initialize
  end
  @@tweet_array = Array.new
  @@accessor_array = Array.new
  @@mutex = Mutex.new
  # These are the twitter credentials for the app registered
  # with 1337scriptdaddy@gmail.com
  TweetStream.configure do |config|
    config.consumer_key       = 'hIl8qNe1VqxKJuxHhWoA'
    config.consumer_secret    = 'iQxdv9Ak6T9fM8DtvdGAdGZGDqfvyiTiCXbPaXI0U8Y'
    config.oauth_token        = '1944743442-3pV23TQz68mT0GeyoINA6HDwRoe78UvWwLRLWuY'
    config.oauth_token_secret = 'w6hMGXVwNKCjL60jhEDXJs1nzhMP0r5Rmsxoa7wSRc'
  #  config.auth_method        = :oauth
  end 
=begin
TweetStream::Daemon.new('tracker').track('term1', 'term2') do |status|
  puts status.text
end
=end

  # getting tweets must be run on a separate thread
  # or the everything else will get blocked.
  # Because tweet_array can be accessed by the tweet_get_thread
  # and by get_tweets, we must surround it with mutex.synchronize
  # so that only one thread can use the array at a time. We don't
  # want a simultaneous read and write or we might get funny values

=begin
  @@initialized = false
  @@stop_thread = true
  def start_tweet_get_thread term0, term1, nterm0, nterm1
    puts term0; puts term1
    tsc = TweetStream::Client.new
    tweet_get_thread = Thread.new do
      if(@@stop_thread and @@initialized)
        puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
        puts "^^^^ you tried to stop me ^^^^^^"
        puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
        @@stop_thread = false
        tsc.stop if @@initialized
        @@initialized = true
        puts "!!!!!!!! Initialized is true !!!!!!!!!!"
      end
      tsc.track(term0,term1) do |status, client|
        
        if(@@stop_thread)
          tsc.stop
          puts "this never prints"
          puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
          puts "^^^^ you tried to stop me ^^^^^^"
          puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
          @@stop_thread = false
        end
        puts term0; puts term1; puts nterm0; puts nterm1
        puts status.text
        tweet = status.text.downcase
        rejected = false
        #rejected = true if (nterm0 != nil and tweet.include? nterm0.downcase)         
        #rejected = true if (nterm1 != nil and tweet.include? nterm1.downcase)         
        unless rejected
          puts status.text
          @@mutex.synchronize {@@tweet_array.push status.text}
        end 
      end
    end
  end
=end

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
=begin
      if( @@term0_tmp == term0 and @@term1_tmp == term1 and @@nterm0_tmp == nterm0 and @@nterm1_tmp == nterm1)
          puts "**** SAME ****"
          puts "!!!!!!!!!!!!!!"
          @@mutex.synchronize {return @@tweet_array}
      else
          puts "**** DIFFERENT ****"
          puts "$$$$$$$$$$$$$$$$$$$"
          @@stop_thread = true
          @@term0_tmp = term0
          @@term1_tmp = term1
          @@nterm0_tmp = nterm0
          @@nterm1_tmp = nterm1
          start_tweet_get_thread term0, term1, nterm0, nterm1
          @@mutex.synchronize {return @@tweet_array}
      end
    
  end 
=end


