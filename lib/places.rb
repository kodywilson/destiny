# This file will contain the various places the player can go
# Town, Tavern, Dungeon and options in each

class Town
  
  def initialize
    # Town is only available as an option in the Dungeon (to return to)
    # initialize is only called the first time, so this greeting is only seen once
    puts "These things always start the same way and your adventure is no exception..."
    puts "You walk into town, scanning each nook and cranny. Most faces are friendly,"
    puts "some are not..."
  end
  
  def choices
    move = 0
    until move == "3"
      begin
        load_data
        puts # formatting
        puts bar_top
        puts stat_bar(@player.name, @player.xp, @player.lvl, @player.coin, @player.cur_hp, @player.cur_mana)
        puts bar_low
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
        # also Tavern should restore the cur_hp and cur_mana to max values!
        puts # formatting
        puts "You enter the tavern. The air is thick with smoke, but you find a place"
        puts "near a window and after a bowl of hearty soup and a bit of rest, you feel"
        puts "greatly replenished."
        puts # formatting
        restore_player
      when move == "2"
        Dungeon.new.choices
      when move == "3"
        # save the player's stats before exit
        save_data
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
    move = 0
    load_data
    bread_crumb = 0
    until move == "2" and bread_crumb == 0
      begin
        puts # formatting
        puts bar_top
        puts stat_bar(@player.name, @player.xp, @player.lvl, @player.coin, @player.cur_hp, @player.cur_mana)
        puts bar_low
        puts # formatting
        puts "Now #{@player.name}, what will you do next?"
        puts "[1]. Go deeper into the dungeon."
        puts "[2]. Return to town."
        prompt; move = gets.chomp
      end while not (move == "1" or move == "2")
      case
      when move == "1"
        puts # formatting
        puts "You walk further into the dark, dank, dirty, dungeon,"
        puts "smirking slightly at your awesome alliteration ability."
        puts # formatting
        bread_crumb = bread_crumb + 1
        random_encounter
      when move == "2"
        if bread_crumb < 1
          save_data
          return
        end
        bread_crumb = bread_crumb - 1
        puts # formatting
        puts "You head back toward town."
        puts # formatting
        random_encounter
      end
    end
  end
  
end
