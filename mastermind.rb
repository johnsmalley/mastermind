
# Mastermind
# Created by John Smalley March 2016
#
# Below is the description of the assignment from The Odin Project
# Build a Mastermind game from the command line where you have 12 turns to
# guess the secret code, starting with you guessing the computer's random code.
#
# Steps direction to the this program up
# 1. Build the game assuming the computer randomly selects the secret colors and
# the human player must guess them. Remember that you need to give the proper
# feedback on how good the guess was each turn!
# 2. Now refactor your code to allow the human player to choose whether she
# wants to be the creator of the secret code or the guesser.
# 3. Build it out so that the computer will guess if you decide to choose your
# own secret colors. Start by having the computer guess randomly (but keeping
# the ones that match exactly).
# 4. Next, add a little bit more intelligence to the computer player so that, if
# the computer has guessed the right color but the wrong position, its next
# guess will need to include that color somewhere.

class Game
	attr_accessor :code, :guess
	
	def initialize
	end

	def play
		keep_playing = true

		while keep_playing
			puts "Would you like to 'guess' or 'set' the code?"
			guess_or_set = gets.chomp.downcase
			if guess_or_set == "guess"
				set_player = AIPlayer.new
				guess_player = HumanPlayer.new
			else
				set_player = HumanPlayer.new
				guess_player = AIPlayer.new
			end

			@code = set_player.generate_code

			12.times do |i|
				puts "Your on guess #{i+1}"
				@guess = guess_player.guess_code
				@hint = self.generate_hint(@guess, @code)
				puts "Hint: #{@hint}"
				break if @hint.count("Correct") == 4
				guess_player.react_to_hint(@hint,guess)
			end

			puts "Guesser Won!" if @hint.count("Correct") == 4
			puts "Setter Won!" if @hint.count("Correct") != 4
			puts "If you want to play again, type 'Yes'"
			keep_playing_answer = gets.chomp.downcase
			keep_playing = false if keep_playing_answer != "yes"
		end
	end

	def generate_hint(guess, code)
		# if correct number and postion then return a single Correct each time
		# if correct number but wrong position then return a single Number Only
		# each time
		guess_hint = Array.new(guess)
		code_hint = Array.new(code)
		hint = []

		guess_hint.each_with_index do |guess, index|
			if guess == code_hint[index]
				hint << "Correct"
				guess_hint[index] = nil
				code_hint[index] = nil
			end
		end

		guess_hint.each do |guess|
			if guess != nil && code_hint.index(guess)
				hint << "Number Only"
				code_hint[code_hint.index(guess)] = nil
			end
		end

		hint
	end
end


class Player
	def react_to_hint(hint,guess)
	end
end

class HumanPlayer < Player
	attr_reader :code
	def generate_code
		puts "Please generate a code"
		puts "Enter a 4 digit code using only numbers between 1 to 6"
		@code = gets.chomp.split(//)
	end

	def guess_code
		puts "What is your guess?"
		puts "Please enter a 4 digit code using only numbers between 1 to 6"
		@guess = gets.chomp.split(//)
	end

	def react_to_hint(hint, guess)
	end
end

class AIPlayer #< Player
	attr_reader :code
	
	def initialize
		# this creates every possible combination to solve the code
		@choices = []
		numbers = ["1","2","3","4","5","6"]
		for a in numbers
			for b in numbers
				for c in numbers
					for d in numbers
						@choices << [a, b, c, d]
					end
				end
			end
		end
	end

	def generate_code
		@code = []
		4.times do
			@code.push rand(1..6).to_s
		end
		return @code
	end

	def guess_code
		guess = @choices[rand(@choices.length)]
		puts "AI Guess: #{guess}"
		return guess
	end

	def react_to_hint(hint,guess)
		# this will delete any combination that is not possible based on the
		# hint
		@choices.delete_if do |choice|
			hint != Game.new.generate_hint(choice,guess)
		end
	end
end

class Board
end

# Starts the game
game = Game.new
game.play

