require_relative 'api'

class Hangman

	def initialize(args)
		@api = Api.new()
    # Most popular letters go in the front
    @vowels = ['e','i','a','o','u']
    @common_letters = ['s','b','g','w','m','n','l','t','h']
    @everything_else = ['c','d','f','j','k','p','q','r','v','x','y','z']
    @common_words = ['a','the','of', 'and', 'to', 'in']  # TODO strings or subarrays?
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
    
    while num_tries_left != "0" && error.nil?
      letter = choose_letter(phrase, num_tries_left)
      response = @api.send_guess_request(response["game_key"], letter)
      error = response["error"]
      old_num_tries_left = num_tries_left

      if error.nil?
        num_tries_left = response["num_tries_left"]
        phrase = load_phrase(response["phrase"])

        if response["state"] == "alive" 
          if num_tries_left == old_num_tries_left
            print "You have #{response["phrase"].count(letter)} '#{letter}' >> " 
          else
            print "Nope '#{letter}' wasn't a good guess. >> "
          end
        else
          # Once I figure out how to win, I'll know the state to test for!
          puts ""
          puts response["state"]
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
    letter = ''
    
    # Have we picked all of the vowels already?
    letter = @vowels.shift if !@vowels.empty? && need_vowel?(phrase)
    
    # Try to make a 'smart' decision based on the word patterns if we've already picked a few letters
    if num_of_tries.to_i < 4 # Randomly chosen number
      # TODO: Commented out because I just broke it as you walked in.
      # letter = educated_guess(phrase)
    end
      
    
    while letter.empty?
      # TODO Make this 'smarter' by looking at common words we could fill in
      letter = @vowels.shift if letter.empty? && !@vowels.empty?  # Try vowels again if we have any
      letter = @common_letters.shift if !@common_letters.empty?
      letter = @everything_else.shift if letter.empty? && !@everything_else.empty?
    end 

    # TODO: Verify we have a letter to return.
    letter
  end
  

  def educated_guess(phrase)
    letter = ""
    
    phrase.each { |word| 
      # Try some common letter combinations
      # th
      if word.include?("t") 
        letter = "h" if !word.include?("h")
        break
      end
      
      # qu
      if word.include?("q") 
        letter = "u" if !word.include?("u")
        break
      end

      # wh
      if word.include?("w") 
        letter = "h" if !word.include?("h")
        break
      end
      
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
