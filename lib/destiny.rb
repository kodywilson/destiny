require "mobs"

def prompt
  print ">> "
end
 
class GameSelect
  attr_accessor :game_select

  def initialize default="default"
    #rspec with user input is more tricky, this allows me to test
    @default = default
    return @game_select = @default if @default != "default"
    #restrict input to valid answers, but don't worry about case
    begin
      puts "Please enter yes or no:"
      prompt; @game_select = STDIN.gets.chomp.downcase
    end while not (@game_select == "yes" or @game_select == "no")
  end

  def outcome
    if @game_select == "yes"
      # this is purely for rspec
      return "Starting a new game, please answer the following questions:" if @default != "default"
      begin
        puts # formatting
        puts "Starting a new game, please answer the following questions:"
        puts "Whould you like to play as a knight or wizard?"
        puts "1. Knight"
        puts "2. Wizard"
      
        prompt; class_choice = gets.chomp
      end while not (class_choice == "1" or class_choice == "2")
      if class_choice == "1"
        @player = Knight.new
        puts "Adventure forth, brave #{@player.name}!"
      elsif class_choice == "2"
        @player = Wizard.new
        puts "Adventure forth, you witty #{@player.name}!"
      end
    elsif @game_select == "no"
      # for rspec
      return "Loading an existing game. Please choose character to play:" if @default != "default"
      puts "Loading an existing game. Please choose character to play:"
    end
  end
  
end

class NewGame
  attr_accessor :save_slot, :char_name
  
  def initialize new_game
    @new_game = new_game
  end
  
  def answer_was game_select="yes"
    @game_select = game_select
    #should probably be a case statement that verifies that only yes, y, no, or n was entered
    # and ignores caps (lower and upper are valid)
    if @game_select == "yes"
      puts # formatting
      puts "Starting a new game, please enter character name:"
#      @character_name = gets
    else
      # Here I will display both save slots with the character names.
      "Please select a game to load:"
    end
  end
  
end
