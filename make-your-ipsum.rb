#Todo

#get self.clean_tweet to work (e.g. remove emojis)
#consolidate make_sentence method

require 'twitter'

class Ipsum
 
@@dummy_ipsum= []
@@opti_ipsum = ["everything's gonna be all right", "look up", "get that dirt of your shoulders"]
@@sentences_per_paragraph = 4
 
 def self.configure
    Twitter.configure do |config|
      config.consumer_key = ENV['CONFIG_CONSUMER_KEY']
      config.consumer_secret = ENV['CONFIG_CONSUMER_SECRET']
      config.oauth_token = ENV['CONFIG_OAUTH_TOKEN']
      config.oauth_token_secret = ENV['CONFIG_OAUTH_TOKEN_SECRET']
    end
  end
 
  def self.clean_tweet(tweet)
  # puts tweet.text.class
  # text is a twitter method to get full tweet/ after cycling through the array in twitter.search
  twitter_strings = tweet.text.split(" ")
  #split words out of tweet full text so I can reject a few words. Reject just deletes. 
  twitter_strings.reject! do |word|
        word.include?("#") or word.include?("RT") or word.include?("http:") or word.include?("@") or word.include?("&lt") or word.include?("&gt")or word.include?("&amp") 
      end
  scrubbed_twitter_strings = twitter_strings.gsub!(/\\U\+\S*/,"") #remove emojis   
  merged_twitter_strings = scrubbed_twitter_strings.join(" ")
  #joined words back together into full tweets
  merged_twitter_strings
  end
 
  def self.push_tweet
     @@dummy_ipsum << self.clean_tweet(tweet)
  end

  # def check_tweet
  #   if self.search_twitter.empty? do
  #   puts "No results right now. Search for so" 
  #   end

  end

  def self.search_twitter
    Twitter.search(@@hashtag_request, :count => 10000).results.each do |tweet| #how do we include all tweets without setting a max count
    end
  end
 
  def self.make_block
    @@number_of_paras.times do 
      @block = make_para
      puts "\n\n"
     end
     print @block
   end
 
   def self.make_para
    @@sentences_per_paragraph.times do
       @paragraph = make_sentence
     end
     print @paragraph
   end

  #   def self.make_opti_sentence
  #   raw_array = @@opti_ipsum.sample(rand(5..7))
  #   last_array_item = raw_array.last
  #       if last_array_item.include?(".") or last_array_item.include?("?") or last_array_item.include?("!") or last_array_item.include?("...")
  #       punc_last_array_item = last_array_item + " "
  #       else
  #       punc_last_array_item = last_array_item + ". "
  #       end
  #   raw_array.pop
  #   revised_array = raw_array << punc_last_array_item
  #   raw_sentence = revised_array.join(" ")
  #   cap_sentence = raw_sentence.capitalize
  #   print cap_sentence
  # end

  def self.make_sentence
    raw_array = @@dummy_ipsum.sample(rand(5..7))
    last_array_item = raw_array.last
        if last_array_item.include?(".") or last_array_item.include?("?") or last_array_item.include?("!") or last_array_item.include?("...")
        punc_last_array_item = last_array_item + " "
        else
        punc_last_array_item = last_array_item + ". "
        end
    raw_array.pop
    revised_array = raw_array << punc_last_array_item
    raw_sentence = revised_array.join(" ")
    cap_sentence = raw_sentence.capitalize
    print cap_sentence
  end

  def self.get_hashtag
    puts "Type in twitter hashtag or user handle (including the # or @ symbol), and we'll build a custom ipsum!"
    @@hashtag_request = gets.chomp
    self.search_twitter
  end
 
  def self.get_para_count
    puts "Thank ya much. How many paragraphs of #{@@hashtag_request} do you want?"
    @@number_of_paras = gets.chomp.to_i
    puts
  end

  # def self.execute_opti_ipsum
  #   self.make_opti_sentence
  #   self.make_para

  # end
 
  def self.execute
    self.configure
    puts "\nWelcome to Make Your Ipsum.\n\n"
    self.get_hashtag
    self.search_twitter
    self.push_tweet
    puts
    self.get_para_count
    self.make_block
  end
 
end

Ipsum.execute
