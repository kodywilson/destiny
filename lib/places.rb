# This file will contain the various places the player can go
# Town, Tavern, Dungeon and options in each

class Town
  
  def initialize
    # only available as an option in the Dungeon (to return to)
    puts "These things always start the same way and your adventure is no exception..."
    puts "You walk into town, scanning each nook and cranny. Most faces are friendly,"
    puts "some are not..."
  end
  
  def choices
    save_file = 'lib/save_game.txt'
    move = 0
    until move == "3"
      begin
        puts # formatting
        puts "Please choose where you will head next:"
        puts "[1]. Ye Old Tavern"
        puts "[2]. Dungeon"
        puts "[3]. Exit game"
        prompt; move = gets.chomp
      end while not (move == "1" or move == "2" or move == "3")
      case
      when move == "1"
        # Put this in Tavern class???
        puts # formatting
        puts "You enter the tavern. The air is thick with smoke, but you find a place"
        puts "near a window and after a bowl of hearty soup and a bit of rest, you feel"
        puts "greatly replenished."
        puts # formatting
        base_class = File.open(save_file) {|f| f.readline}.chomp
        if base_class == "Knight"
          @player = Knight.new
        elsif base_class == "Wizard"
          @player = Wizard.new
        end
        # Retrieve player xp, lvl, coin, and name then return the restored values
        # Could this be replaced with a hash, maybe in json?
        @player.xp   = read_one_line(save_file, 2)
        @player.lvl  = read_one_line(save_file, 3)
        @player.coin = read_one_line(save_file, 4)
        @player.name = read_one_line(save_file, 5)
        @player
      when move == "2"
        Dungeon.new.choices
      when move == "3"
        # This needs to save the players stats before exit
        # Should probably convert the read from file to restore stats to a module
        exit
      end
    end
  end

end

class Tavern
  
  # only available as an option in the Town
  # This class will essentially "heal" the player by restoring mana and hp
  
end

class Dungeon
  
  # can go here from town, will spawn random encounters, etc.
  def initialize
    puts # formatting
    puts "You have entered the dungeon! DUM DUM DUM!!"
  end
  
def choices
    save_file = 'lib/save_game.txt'
    move = 0
    until move == "2"
      begin
        puts # formatting
        puts "Now friend, what will you do next?"
        puts "[1]. Go deeper into the dungeon."
        puts "[2]. Return to town."
        prompt; move = gets.chomp
      end while not (move == "1" or move == "2")
      case
      when move == "1"
        puts # formatting
        puts "You walk further into the dark, dank, dirty, dungeon, smirking slightly"
        puts "at your mad alliteration sk1llz."
        puts # formatting
          
      when move == "2"
        return
      end
    end
  end
  
end
