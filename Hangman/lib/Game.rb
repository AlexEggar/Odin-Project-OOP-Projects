require "yaml"




class Player
  def initialize

  end


  def guess
    begin
    puts 'Enter Guess'
    guess = gets.chomp
    end until check_input(guess) == guess
    guess
  end

  def check_input(guess)
    if /^[A-z]$/.match(guess)
      guess
    end
  end

end

class Game
  attr_accessor :word

  def initialize
    @guesses = 8

    @word = File.readlines('/home/alex/TOP/Hangman/lib/5desk.txt').sample.chomp
    @placeholder = '_ ' * (@word.length)
    letters_used = []
    play
  end

  def play

    player = Player.new

    until @placeholder == @word or @guesses == 0 do
      puts "Word:#{@placeholder}"
      savecheck
      playerguess = player.guess
      check_guess(playerguess)
    end
  end


  def check_guess(playerguess)
    puts playerguess
    if @word.include?(playerguess)

      index = @word.index(playerguess)
      @placeholder[index] = playerguess
    else
      @guesses -= 1
    end
  end

  def savecheck
    puts 'Would you like to save the game and exit?'
    input = gets.chomp.downcase
    if  input == 'yes' or input == 'y'
      save_game
    end
  end

  def save_game
  puts 'Enter a Save Name'
  filename = gets
  yaml = YAML::dump(self)
  File.open("/home/alex/TOP/Hangman/Saves/#{filename}", "w") {|file| file.puts yaml}
  exit
  end



end
