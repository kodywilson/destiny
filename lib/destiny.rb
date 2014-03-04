require "mobs"

class GameSelect
  attr_accessor :game_select

  def initialize
    #restrict input to valid answers, but don't worry about case
    begin
      puts "Please enter yes or no:"
      @game_select = STDIN.gets.chomp.downcase
    end while not (@game_select == "yes" or @game_select == "no")
  end

  def outcome
    if @game_select == "yes"
      puts "Starting a new game, please enter character name:"
      puts # for formatting
    else
      puts "Loading an existing game. Please choose character to play:"
      puts # for formatting
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
      puts # for formatting
      puts "Starting a new game, please enter character name:"
      @character_name = gets
    else
      # Here I will display both save slots with the character names.
      "Please select a game to load:"
    end
  end
  
end
