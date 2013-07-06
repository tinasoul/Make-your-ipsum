require 'twitter'

class Ipsum
  @@opti_ipsum = ["Don't worry about a thing", "Cause every little thing gonna be all right.", "Rise up this mornin'", "Smiled with the risin' sun", "Three little birds","On your doorstep", "Singin' sweet songs", "Of melodies pure and true", "Sayin', This is my message to you-ou-ou","Tupac cares if don't nobody else care", "But please don't cry, dry your eyes, never let up" "Forgive but don't forget, girl keep your head up", "And when he tells you you ain't nuttin don't believe him", "Keep ya head up, oooo child things are gonna get easier", "And it's crazy, it seems it'll never let up, but please... you got to keep your head up", "Here comes the sun (doo doo doo doo)","Little darling, the smiles returning to the faces","It's all right", "Just dance, gonna be okay, da da doo-doo-mmm", "Just dance, spin that record babe, da da doo-doo-m", "Let it go", "Feel free right now, go do what you wanna do", "Can’t let nobody take it away from you, from me, from we","No time for moping around, are you kidding?","And no time for negative vibes 'cause I’m winning", "It’s been a long week, I put in my hardest", "Gonna live my life, feels so good to get it right", "So I like what I see when I’m looking at me when I’m walking past the mirror", "Got my head on straight, I got my vibe right", "See I wouldn’t change my life, my life’s just fine", "Get, that, dirt off your shoulder", "Big wheel keep on turnin'", "Proud mary keep on burning", "Wake up everybody", "No more sleepin' in bed", "No more backward thinkin'", "Time for thinkin' ahead", "Wake up, all the builders", "Time to build a new land", "I know we can do it", "If we all lend a hand"]
  #bob marley, tupac, beatles, lady gaga, mary j blige, jay-z, tina turner, john legend


  @@paragraphs_for_opti_block = 3
  @@sentences_per_paragraph = 4
 
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

    raw_array = messages_array.sample(rand(5..7))
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
    puts "\nThank ya much. How many paragraphs of #{@@hashtag_request} do you want?"
    @@number_of_paras = gets.chomp.to_i
    puts
  end

  def self.get_hashtag
    puts "Type in twitter hashtag or user handle (including the # or @ symbol), and we'll build a custom ipsum!\n\n"
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
      puts "\nNo results right now, so here's some opti-ipsum to brighten your day!\n\n"
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


