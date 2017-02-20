require_relative 'lib/Game'


class Hangman
attr_reader :game
def initialize
puts "Welcome to Hangman what would you like to do?"
puts "1.New Game"
puts "2.Load Saved Game"
puts "3.Exit"
choice = gets.chomp

case choice
  when  "1"
    new_game
  when "2"
    list_saves
    load_game
  when "3"
    exit
  else
    puts "Enter 1,2 or 3 please"
  end
end

def new_game
  @game = Game.new
end

def load_game(savefile = gets)
  Dir.chdir("Saves")
  yaml = File.read(savefile)
  @game = YAML::load(yaml)
  @game.play
end

def list_saves

puts Dir.entries("Saves")

end


end
game = Hangman.new
