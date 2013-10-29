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

  @@term0 = ""
  @@term1 = ""
  @@first_wakeup = true
  @@stop = false
  @@reset_terms = false
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
  

  # note that the thread is started and stopped every time 
  # this function is called. This is not ideal, since the
  # user won't update the search terms often. Works for now...

  @@term0_old = ""
  @@term1_old = ""
  @@nterm0_old = ""
  @@nterm1_old = ""
  @@nothing = Array.new
  def get_tweets term0, term1, nterm0, nterm1

    puts "term0 == #{term0 == nil}"; puts "term1 == #{term1 ==nil}"
    # case 1: blank terms
    if( (term0 == nil and term1 == nil) or (term0 == "" and term1 == "") )
      puts "!!!!!!! nothing !!!!!!!"
      unless @@first_wakeup
        @@stop = true
      end
      return @@nothing
    

    elsif ( @@first_wakeup )
      @@first_wakeup = false
      @@term0_old = term0
      @@term1_old = term1
      @@term0 = term0
      @@term1 = term1

      @@stream_th.wakeup
      sleep 1
      @@mutex.synchronize {return @@tweet_array}


    # case 2: different from last time
    elsif ( term0 != @@term0_old or term1 != @@term1_old )
      puts "<><><><><><><>><><><> NEW TERMS <><><><><><><><><><><><><"
      @@term0_old = term0
      @@term1_old = term1
      @@term0 = term0
      @@term1 = term1

      
      @@reset_terms = true
      sleep 1
      @@stream_th.wakeup unless @@stream_th.alive?
      
      sleep 1
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
 
