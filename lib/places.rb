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
  
  # can get here from town, initialize just gives a one time (per visit) message
  def initialize
    puts # formatting
    rand_greet = dice(3)
    rand_greet = "You have entered the dungeon! DUM DUM DUM!!" if rand_greet == 1
    rand_greet = "Stepping into the dungeon, you prepare for adventure." if rand_greet == 2
    rand_greet = "As you enter the dungeon, you notice strange markings along the walls..." if rand_greet == 3
    puts rand_greet
  end
  
  def choices
    move = 0
    load_data
    bread_crumb = 0 # helps track how deep you go into the dungeon
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
      # apply food buff
      @player.cur_hp = @player.cur_hp + @player.lvl if @player.buff_food == true
      # prevent food buff from raising current health points above maximum
      @player.cur_hp = @player.hp if @player.cur_hp > @player.hp
      # now apply drink buff
      @player.cur_mana = @player.cur_mana + @player.lvl if @player.buff_drink == true
      # prevent drink buff from raising current mana points above maximum
      @player.cur_mana = @player.mana if @player.cur_mana > @player.mana
      case
      when move == "1"
        puts # formatting
        rand_msg = dice(3)
        rand_msg = "You walk further into the dark, dank, dirty, dungeon, smirking slightly at your awesome alliteration ability." if rand_msg == 1
        rand_msg = "You feel a slight draft and your torch flickers briefly..." if rand_msg == 2
        rand_msg = "More strange markings, they seem to mean something, but what and who wrote them?" if rand_msg == 3
        puts rand_msg
        puts # formatting
        bread_crumb = bread_crumb + 1
        random_encounter
      when move == "2"
        if bread_crumb <= 1
          puts # formatting
          puts "You make it back to town in one piece!"
          puts # formatting
          # remove food buffs from player when they leave the dungeon
          @player.buff_food = false
          @player.buff_drink = false
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
        room_cost = @player.lvl*3
        nourish_cost = @player.lvl*2
        puts "What would you like to do in the tavern, #{@player.name}?"
        puts "[1]. Buy some food.    | Cost: #{nourish_cost} coins."
        puts "[2]. Buy a drink.      | Cost: #{nourish_cost} coins."
        puts "[3]. Rest.             | Cost: #{room_cost} coins."
        puts "[4]. Leave the tavern."
        prompt; move = gets.chomp
      end while not (move == "1" or move == "2" or move == "3" or move == "4")
      case
      when move == "1"
        if @player.coin >= @player.lvl*2
          @player.buff_food = true
          puts # formatting
          puts "You find a seat at an open table and the waiter approaches to take your order."
          puts # formatting
          puts "The waiter tells you the food is so darn good, that it will help sustain your"
          puts "health as you travel in the dungeon."
          puts # formatting
          puts "You order and enjoy a delicious meal, #{@player.name}, you really do feel swell!"
          @player.coin = @player.coin - @player.lvl*2
          save_data
        else
          puts # formatting
          puts "You can't afford a meal! Go to the dungeon and earn some money!"
        end
      when move == "2"
        if @player.coin >= @player.lvl*2
          @player.buff_drink = true
          puts # formatting
          puts "You sally up to the bar and the barkeep approaches to take your order."
          puts # formatting
          puts "The barkeep tells you the wine is so fancy, that it will help sustain your"
          puts "mana as you travel in the dungeon."
          puts # formatting
          puts "You swirl the wine, sniff, then take a sip, #{@player.name}, you really do feel superior!"
          @player.coin = @player.coin - @player.lvl*2
          save_data
        else
          puts # formatting
          puts "You can't afford wine, you churl! Go to the dungeon and earn some money!"
        end
      when move == "3"
        if @player.coin >= @player.lvl*3
          health = @player.cur_hp
          mana   = @player.cur_mana
          @player.coin = @player.coin - @player.lvl*3
          restore_player
          health = @player.cur_hp - health
          mana   = @player.cur_mana - mana
          puts # formatting
          puts "You pay for a small room and get a good night of rest."
          puts "Resting has restored #{health} health points and #{mana} points of mana."
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
