require 'twitter'

class Ipsum
  @@opti_ipsum = ["everything's gonna be all right", "look up", "smiley"]
  @@paragraphs_for_opti_block = 5
  @@sentences_per_paragraph = 8
 
  def self.configure
    Twitter.configure do |config|
      config.consumer_key = ENV['CONFIG_CONSUMER_KEY']
      config.consumer_secret = ENV['CONFIG_CONSUMER_SECRET']
      config.oauth_token = ENV['CONFIG_OAUTH_TOKEN']
      config.oauth_token_secret = ENV['CONFIG_OAUTH_TOKEN_SECRET']
    end
  end

  def self.search_twitter
    @@tweet_messages_array = Twitter.search(@@hashtag_request, :count => 10000).results.collect do |tweet| 
      tweet.full_text 
    end
  end
 
  def self.make_block(num_paragraphs = nil)
    num_paragraphs ||= @@number_of_paras

    num_paragraphs.times do 
      puts make_para
      puts "\n\n"
    end
  end
 
  def self.make_para
    paragraph_sentences = []
    @@sentences_per_paragraph.times do
      paragraph_sentences << make_sentence
    end
    paragraph_sentences.join(" ")
  end

  def self.make_sentence(messages_array = nil)
    messages_array ||= @@tweet_messages_array

    raw_array = messages_array.sample(rand(1..3))
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

    cap_sentence
  end

  def self.get_para_count
    puts "Thank ya much. How many paragraphs of #{@@hashtag_request} do you want?"
    @@number_of_paras = gets.chomp.to_i
    puts
  end

  def self.get_hashtag
    puts "Type in twitter hashtag or user handle (including the # or @ symbol), and we'll build a custom ipsum!"
    @@hashtag_request = gets.chomp
  end
 

  def self.execute_opti_ipsum
    @@tweet_messages_array = @@opti_ipsum
    self.make_block(@@paragraphs_for_opti_block)
  end
 
  def self.execute
    configure
    puts "\nWelcome to Make Your Ipsum.\n\n"
    get_hashtag
    search_twitter


    if @@tweet_messages_array.empty?
      puts "No results right now, so here's some ipsum anyway!"
      execute_opti_ipsum
    else
      clean_tweets
      get_para_count
      make_block
    end
  end

  private

  # Remove 
  def self.clean_tweets
    @@tweet_messages_array.collect! do |tweet_message|
      approved_words_array = tweet_message.split(" ").reject! do |word| 
        word.include?("#") || word.include?("RT") || word.include?("http:") || word.include?("@") || word.include?("&lt") || word.include?("&gt") || word.include?("&amp") 
      end

      approved_words_array.join(" ")
    end
  end
 
end

Ipsum.execute


# def self.search_twitter
#   @@results = Twitter.search(...)
# end

# def self.clean_tweet
#   if @@results.map
# end
# if results.empty?
#   ...
# else
#   results.map do |tweet|
#     tweet.gsub()
#   end
# end
