require_relative 'api'

class Hangman

	def initialize(args)
		@api = Api.new()
    # Most popular letters go in the front
    @vowels = ['e','i','a','o','u']
    @consonants = ['n','l','t','h','r','c','s','b','g','w','m','d','f','j','k','p','q','v','x','y','z']
    @common_words = ['a','on','be','out', 'put','the','she','you','about','easy', 'away', 'from','can','been', 'of', 'and', 'to', 'in', 'alarming', 'rate', 'name', 'well', 'tell', 'we','ball', 'two', 'were','this', 'have', 'toward']  # TODO put into a file to upload and in some more efficient order
	end

	def run

    error = nil
    response = @api.send_new_game_request("test@test.com")
    error = response["error"]
    
    if !error.nil?
      puts "Error loading new game request #{error}"
      return
    end
    
    num_tries_left = response["num_tries_left"]
    phrase = load_phrase(response["phrase"])
    state = response["state"]
    
    while num_tries_left != "0" && error.nil? && state == "alive"
      
      letter = choose_letter(phrase, num_tries_left)
      response = @api.send_guess_request(response["game_key"], letter)
      error = response["error"]
      old_num_tries_left = num_tries_left

      if error.nil?
        num_tries_left = response["num_tries_left"]
        phrase = load_phrase(response["phrase"])
        state = response["state"]

        if state == "alive" 
          if num_tries_left == old_num_tries_left
            print "You have #{response["phrase"].count(letter)} '#{letter}' >> " 
          else
            print "Nope '#{letter}' wasn't a good guess. >> "
          end
        else
          if state == "won"
            puts "YOU WON!!"
          else
            puts "The game is over"
          end
          
        end

        puts response["phrase"]

      else
        puts "An error occurred: #{error}."
      end
    end
	end

  # load the phrase in the format we want.
  def load_phrase(response_phrase)
    response_phrase.split # split phrase into words
  end
  
  
  # Choose a letter based on some brilliant deduction
  def choose_letter(phrase, num_of_tries)
    letter = nil
    
    # Have we picked all of the vowels already?
    letter = @vowels.shift if !@vowels.empty? && need_vowel?(phrase)
    
    # Try to make a 'smart' decision based on the word patterns if we've already picked a few letters
    if letter.nil? && num_of_tries.to_i < 4 # Randomly chosen number
      # TODO: Commented out because I just broke it as you walked in.
       letter = educated_guess(phrase)
    end
      
    while letter.nil?
      # TODO Make this 'smarter' by looking at common words we could fill in
      letter = @vowels.shift if letter.nil? && !@vowels.empty?  # Try vowels again if we have any
      letter = @consonants.shift if letter.nil? && !@consonants.empty?
    end 

    # TODO: Verify we have a letter to return.
    letter
  end
  

  def educated_guess(phrase)
    letter = nil
    
    phrase.each { |word|
      # Has this word been solved?
      if !word[/_/].nil?
        # Only get words with the same length
        #TODO: Refactor to include subwords like ball in football
        subset_words = @common_words.select{|common_word| common_word.length == word.length}
        subset_words.each { |common_word|
          word_regexp = /#{word.gsub('_', '\w')}/
          if word_regexp.match(common_word)
            word_no_underscore_re = Regexp.new("[" + word.gsub("_", "") + "]")
            remaining_characters = common_word.gsub(word_no_underscore_re,'')
            everything = @vowels + @consonants
            remaining_characters = remaining_characters.split("").delete_if{|letter| !everything.include?(letter)}
            if remaining_characters.length > 0
              letter = remaining_characters.first
              #TODO: Clean this up too
              @vowels.delete(letter) if !@vowels.empty?
              @consonants.delete(letter) if !@consonants.empty?
              break
            end
          end
        }
        
        # Try some common letter combinations
        # TODO: Make this smarter > Regular Expressions
        # th
        if letter.nil? && word.include?("t") && !word.include?("h") && @consonants.include?("h")
          letter = "h"
          @consonants.delete("h")
          break
        end

        # qu
        if word.include?("q") && !word.include?("u") && @vowels.include?("u")
          letter = "u"
          @vowels.delete("u")
          break
        end

        # wh
        if word.include?("w") && !word.include?("h") && @consonants.include?("h")
          letter = "h"
          @consonants.delete("h")
          break
        end
  
      end
      break if !letter.nil?
    }
    
    letter
    
  end
  
  # TODO: Refactor: Problem with need_vowel is we might have two vowels in a word and we might never end up picking it.
  #  So either remove this check and just get all of the vowels first, or add it back in later if we've gotten to the everything_else bucket.
  
  def need_vowel?(phrase)
    # Don't pick vowels if every sentance already has one
    no_vowel = false
    phrase.each {|word|
      #TODO: Refactor!! the include condition
      if !word.include?('a') && !word.include?('e') && !word.include?('i') && !word.include?('o') && !word.include?('u')
        no_vowel = true
        break
      end
    }
    no_vowel
  end
  
end

if __FILE__ == $0
  x = Hangman.new(ARGV)
  x.run
end
