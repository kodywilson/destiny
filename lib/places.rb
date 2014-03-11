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
        puts "[1]. The Dungeon"
        puts "[2]. Ye Old Tavern"
        puts "[3]. Exit Game"
        prompt; move = gets.chomp
      end while not (move == "1" or move == "2" or move == "3")
      case
      when move == "1"
        Dungeon.new.choices
      when move == "2"
        Tavern.new.choices
      when move == "3"
        # save the player's stats before exit
        save_data
        exit
      end
    end
  end

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
          puts "You make it back to town in one piece!"
          puts # formatting
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

class Tavern
  
  # only available as an option in the Town
  # The tavern will "heal" the player by restoring mana and hp
  def initialize
    load_data
    puts # formatting
    puts "You enter the tavern. The air is thick with smoke, but the fire in the hearth"
    puts "is warm and inviting."
    puts if @player.cur_hp < @player.hp # formatting
    puts "Some rest would probably do you good, #{@player.name}." if @player.cur_hp < @player.hp
    puts # formatting
  end
  
  def choices
    move = 0
    until move == "4"
      begin
        puts # formatting
        puts bar_top
        puts stat_bar(@player.name, @player.xp, @player.lvl, @player.coin, @player.cur_hp, @player.cur_mana)
        puts bar_low
        puts # formatting
        room_cost = @player.lvl*2
        puts "What would you like to do in the tavern, #{@player.name}?"
        puts "[1]. Buy some food."
        puts "[2]. Buy a drink."
        puts "[3]. Rest. | Cost: #{room_cost} coins."
        puts "[4]. Leave the tavern."
        prompt; move = gets.chomp
      end while not (move == "1" or move == "2" or move == "3" or move == "4")
      case
      when move == "1"
        puts # formatting
        puts "You find a seat at an open table and the waiter approaches to take your order."
        puts # formatting       
      when move == "2"
        puts # formatting
        puts "You sally up to the bar and have a drink."
        puts # formatting
      when move == "3"
        if @player.coin >= @player.lvl*2
          health = @player.cur_hp
          mana   = @player.cur_mana
          restore_player
          health = @player.cur_hp - health
          mana   = @player.cur_mana - mana
          puts # formatting
          puts "You pay for a small room and get a good night of rest."
          puts "Resting has restored #{health} health points and #{mana} points of mana."
          @player.coin = @player.coin - @player.lvl*2
        else
          puts # formatting
          puts "You can't afford a room! Hit the dungeon and earn some money!"
        end
      when move == "4"
        puts # formatting
        puts "Feeling much better, you step out of the tavern and back into town."
        save_data
        return
      end
    end
  end

end
