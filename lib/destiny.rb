require "json"
require "game_mechanics"
require "mobs"
require "places"
require "choice"

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
    #rspec with user input is more tricky, this allows me to test no response
    @default = default
    return @yes_no = @default if @default != "default"
    yes_no
  end

  def outcome
    if @yes_no == "yes"
      begin
        puts # formatting
        puts "_"*50
        puts "Starting a new game, please answer the following questions:"
        c = Choice.new "Whould you like to play as a knight, wizard, cleric, or rogue?",
          {
            "1" => "Knight",
            "2" => "Wizard",
            "3" => "Cleric",
            "4" => "Rogue"
          }
          class_choice = c.prompt
      end while not (class_choice == "1" or class_choice == "2" or class_choice == "3" or class_choice == "4")
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
      elsif class_choice == "3"
        @player = Cleric.new
      elsif class_choice == "4"
        @player = Rogue.new
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
    elsif @yes_no == "no"
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
  # Not using this right now. Later, I hope to support multiple characters and then
  # I will move the newgame stuff into here. Need a save file with multiple lines support first
  attr_accessor :save_slot, :char_name

  def initialize new_game
    @new_game = new_game
  end

end
