require 'twitter'

class Ipsum
  @@dummy_ipsum= []
  @@opti_ipsum = ["everything's gonna be all right", "look up", "smiley"]
  @@paragraphs_for_opti_block = 5
  @@sentences_per_paragraph = 4
 
  def self.configure
    Twitter.configure do |config|
      config.consumer_key = ENV['CONFIG_CONSUMER_KEY']
      config.consumer_secret = ENV['CONFIG_CONSUMER_SECRET']
      config.oauth_token = ENV['CONFIG_OAUTH_TOKEN']
      config.oauth_token_secret = ENV['CONFIG_OAUTH_TOKEN_SECRET']
    end
  end
 
  def self.push_tweets
     @@dummy_ipsum << @@clean_tweet
  end

  def self.check_tweets
    if @@tweet.empty? 
      puts "No results right now so we've loaded some opti_ipsum for you!"
      self.execute.opti_ipsum
    end
  end


  def self.search_twitter
    scrubbed_array = []
    Twitter.search(@@hashtag_request, :count => 10000).results.map do |object| 
     @@tweet = object.full_text #strings
    end
     word_array = @@tweet.split(" ") #an array of words in each tweet
      word_array.reject! do |word| 
        word.include?("#") or word.include?("RT") or word.include?("http:") or word.include?("@") or word.include?("&lt") or word.include?("&gt")or word.include?("&amp") 
      end
    word_array.each do |word|   
      scrubbed_array <<  word.gsub(/\\U\+\S*/,"") #remove emojis 
    end
    @@clean_tweet = scrubbed_array.join(" ") #clean_tweet is a string
  end

  def self.make_fixed_block
    @@paragraphs_for_opti_block.times do 
      @block = make_para
      puts "\n\n"
    end
    print @block
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

  def self.make_opti_sentence
    raw_array = @@opti_ipsum.sample(rand(5..7))
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

  def self.get_para_count
    puts "Thank ya much. How many paragraphs of #{@@hashtag_request} do you want?"
    @@number_of_paras = gets.chomp.to_i
    puts
  end

  def self.get_hashtag
    puts "Type in twitter hashtag or user handle (including the # or @ symbol), and we'll build a custom ipsum!"
    @@hashtag_request = gets.chomp
    self.search_twitter
  end
 

  def self.execute_opti_ipsum
    self.make_opti_sentence
    self.make_para
    self.make_fixed_block
  end
 
  def self.execute
    self.configure
    puts "\nWelcome to Make Your Ipsum.\n\n"
    self.get_hashtag
    self.search_twitter
    self.check_tweets
    self.push_tweets
    puts
    self.get_para_count
    self.make_block
  end
 
end

Ipsum.execute


