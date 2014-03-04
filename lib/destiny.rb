class NewGame
  attr_accessor :new_game
  
  def initialize new_game
    @new_game = new_game
  end
  
  def game_select
    #should probably be a case statement that verifies that only yes, y, no, or n was entered
    # and ignores caps (lower and upper are valid)
    if @new_game == "yes" || "y"
      puts "Starting a new game, please enter character name."
    else
      puts "Please select a game to load."
    end
  end
  
end
