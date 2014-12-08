require 'curb'
require 'json'

class Api
    URL_BASE = "http://hangman.coursera.org/hangman/game"

    # Create a new game associated with the given e-mail address and return the
    # state of the new game.

    # An e-mail address may be associated with multiple games.

    # This returns a dict with the new game state.  This dict has the following
    # keys:

    #     game_key
    #         A unique string identifying the game.

    #     phrase
    #         The partially revealed phrase.  The phrase will be in English and
    #         may contain punctuation (which do not need to be guessed). Hidden
    #         letters are indicated by an underscore ("_") character.  For
    #         example, this may be: "_e __e___".

    #     state
    #         The current state of the game.  This can be one of {"alive", "won",
    #         "lost"}.  "alive" means that the game is in progress.  "won" means
    #         that you have won.  "lost" means that you have lost. 

    #     num_tries_left
    #         The number of incorrect guesses that you can make before you lose.
    #         For example, if this is 0, and you have not yet won, you will lose
    #         on your next incorrect guess.
    def send_new_game_request(email)
        url = URL_BASE
        params = {email: email}
        return _post(url, params)
    end

    # Send a guess for an existing game.

    # `game_key` is the key for the game for which you want to send a guess.
    # This corresponds to the game_key value of the game state returned by
    # send_new_game_request.

    # `guess` is the character to guess.

    # This returns a dict with the new game state.  This dict has the following
    # keys:

    #     game_key
    #         A unique string identifying the game.

    #     phrase
    #         The partially revealed phrase.  The phrase will be in English and
    #         may contain punctuation (which do not need to be guessed). Hidden
    #         letters are indicated by an underscore ("_") character.  For
    #         example, this may be: "_e __e___".

    #     state
    #         The current state of the game.  This can be one of {"alive", "won",
    #         "lost"}.  "alive" means that the game is in progress.  "won" means
    #         that you have won.  "lost" means that you have lost. 

    #     num_tries_left
    #         The number of incorrect guesses that you can make before you lose.
    #         For example, if this is 0, and you have not yet won, you will lose
    #         on your next incorrect guess.
    def send_guess_request(game_key, guess)
        url = "%s/%s" % [URL_BASE, game_key]
        params = {guess: guess}
        return _post(url, params)
    end

    def _post(url, params)
        c = Curl::Easy.http_post(url, params.to_json
            ) do |curl|
              curl.headers['Accept'] = 'application/json'
              curl.headers['Content-Type'] = 'application/json'
            end
        data = JSON.parse(c.body_str)
        return data
    end
end
