require "json"
require "game_mechanics"
require "mobs"
require "places"

include GameMechanics

def choose_name
  puts #formatting
  puts "Please enter your new character's name:"
  prompt; gets.chomp
end

def read_one_line(file_name, line_number)
  File.open(file_name) do |file|
    current_line = 1
    file.each_line do |line|
      return line.chomp if line_number == current_line
      current_line += 1
    end
  end
end

class GameSelect
  attr_accessor :game_select

  def initialize default="default"
    #rspec with user input is more tricky, this allows me to test
    @default = default
    return @game_select = @default if @default != "default"
    yes_no
  end

  def outcome
    if @game_select == "yes"
      # this is purely for rspec
#      return "Starting a new game, please answer the following questions:" if @default != "default"
      begin
        puts # formatting
        puts "_"*50
        puts "Starting a new game, please answer the following questions:"
        puts "Whould you like to play as a knight or wizard?"
        puts "[1]. Knight"
        puts "[2]. Wizard"
        prompt; class_choice = gets.chomp
      end while not (class_choice == "1" or class_choice == "2")
      begin
        player_name = choose_name
        puts #formatting
        puts "You have chosen #{player_name} as your character's name. Is this correct?"
        puts "Please enter [yes] to confirm."
        prompt; confirm_name = STDIN.gets.chomp.downcase
      end while not (confirm_name == "yes")
      if class_choice == "1"
        @player = Knight.new
      elsif class_choice == "2"
        @player = Wizard.new
      end
      # Set player name, write attributes to save file, then return player to binary
      @player.name = "#{player_name}"
      save_data
      # Intro for new players
      puts #formatting
      puts "Prepare ye, #{@player.name} for great adventure!"
      puts "Ye are a young #{@player.class} with magnificent deeds ahead of ye!"
      puts # formatting
      @player
    elsif @game_select == "no"
      # for rspec
      return "Loading the existing game." if @default != "default"
      puts # formatting
      puts "Loading the existing game."
      puts # formatting
      @player = load_data
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
