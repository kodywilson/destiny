module GameMechanics
  
  @@save_file = '../lib/save_game.json'
  
  def prompt
    print ">> "
  end
  
  def yes_no
    #restrict input to valid answers, but don't worry about case
    begin
      puts "Please enter [yes] or [no]:"
      prompt; @game_select = STDIN.gets.chomp.downcase
    end while not (@game_select == "yes" or @game_select == "no")
  end
  
  def save_data
    case
    when (0..1000).include?(@player.xp)
      @player.lvl = 1
    when (1001..2500).include?(@player.xp)
      @player.lvl = 2
    when (2501..5000).include?(@player.xp)
      @player.lvl = 3
    when (5001..8000).include?(@player.xp)
      @player.lvl = 4
    when (8001..11500).include?(@player.xp)
      @player.lvl = 5
    when (11501..15000).include?(@player.xp)
      @player.lvl = 6
    end
    save_info = {
      role:     @player.class,
      cur_hp:   @player.cur_hp,
      cur_mana: @player.cur_mana,
      xp:       @player.xp,
      lvl:      @player.lvl,
      coin:     @player.coin,
      name:     @player.name
    }
    File.open(@@save_file, "w") do |f|
      f.write(save_info.to_json)
    end
  end
  
  def load_data
    load_info = JSON.parse(File.read(@@save_file))
    role = load_info['role']
    if role == "Knight"
      @player = Knight.new
    elsif role == "Wizard"
      @player = Wizard.new
    end
    # Set stats based off information in load_info
    @player.lvl      = load_info['lvl']
    @player.xp       = load_info['xp']   
    @player.coin     = load_info['coin']
    @player.name     = load_info['name']
    @player.cur_hp   = load_info['cur_hp']
    @player.cur_mana = load_info['cur_mana']
    # Adjust stats based off player level
    @player.hp       = @player.hp*@player.lvl
    @player.mana     = @player.mana*@player.lvl
    @player.dmg      = @player.dmg*@player.lvl
    @player
    # I was trying to do the above assignments with iteration, there has to be a way!
#    load_info.each do |attribute, value|
#      @player.#{attribute} = value unless attribute == "role"
#    end  
  end

  def restore_player
    @player.cur_hp   = @player.hp
    @player.cur_mana = @player.mana
    save_data
  end

  def bar_top
    "_"*27 + " STATS " + "_"*27
  end
  
  def stat_bar name, xp, lvl, coin, cur_hp, cur_mana
    "  Name: #{name} | XP: #{xp} | Lvl: #{lvl} | Coin: #{coin} | HP: #{cur_hp} | Mana: #{cur_mana}"
  end
  
  def bar_low
    "-"*61
  end
  
  def player_croaks
    puts # formatting
    puts "It happens to the best of us #{@player.name}."
    puts "Fortunately for you, the game of Destiny never ends."
    puts "The game will exit now and you can restart in town."
    puts # formatting
    puts "Better luck next time, eh?"
    exit
  end
  
  def combat bad_guy
    # create an opponent
    @bad_guy = bad_guy.new
    # scale power of opponent to level of player
    @bad_guy.cur_hp       = @bad_guy.hp*@player.lvl
    @bad_guy.cur_mana     = @bad_guy.mana*@player.lvl
    @bad_guy.dmg      = @bad_guy.dmg*@player.lvl
    puts @bad_guy.name + " says, you kill my father, now you will die!!" unless (@bad_guy.name == "ROUS" or @bad_guy.name == "Skeleton")
    move = 0
    until move == "2"
      begin
        puts # formatting
        puts bar_low + "--"
        puts " #{@player.name} - HP: #{@player.cur_hp} - Mana: #{@player.cur_mana} | - VS - | #{@bad_guy.name} - HP: #{@bad_guy.cur_hp} - Mana: #{@bad_guy.cur_mana}"
        puts bar_low + "--"
        puts # formatting
        puts "#{@bad_guy.name} vs. #{@player.name}, what will you do?"
        puts "[1]. Attack."
        puts "[2]. Run."
        prompt; move = gets.chomp
      end while not (move == "1" or move == "2")
      case
      when move == "1"
        puts # formatting
        if @player.class.to_s == "Knight"
          puts "#{@player.name} swings the mighty sword at the #{@bad_guy.name}."
          puts # formatting
          dmg_mod = (@player.str-10)/2 # knights use their str for damage mod
          @dmg_dlt = dice(@player.dmg) + dmg_mod
        elsif @player.class.to_s == "Wizard"
          begin
            puts "How many magic darts will you shoot?"
            puts "[1]."
            puts "[2]."
            puts "[3]."
          prompt; darts = gets.chomp.to_i
          end while not (darts == 1 or darts == 2 or darts == 3)
          puts # formatting
          puts "#{@player.name} conjures #{darts} magic darts that zip toward the #{@bad_guy.name}."
          dmg_mod = (@player.int-10)/2 # wizards use their int for damage mod
          @dmg_dlt = dice(@player.dmg) + darts*@player.lvl + dmg_mod# more darts more damage, scales with level
          @player.cur_mana = @player.cur_mana - darts*@player.lvl # more darts more mana spent, scales with level
        end
        miss_chance = dice(100)
        agi_boost = (@bad_guy.agi-10)*2 + @bad_guy.dodge
        if (1..agi_boost).include?(miss_chance)
            puts @bad_guy.name + " jumps out of the way, avoiding being hit by " + @player.name + "!"
            puts # formatting
        else
          @dmg_dlt = @dmg_dlt - @bad_guy.armor/4
          @dmg_dlt = 0 if @dmg_dlt < 1
          puts #formatting
          puts "You deal #{@dmg_dlt} damage to the #{@bad_guy.name}." unless @dmg_dlt < 1
          puts # formatting
          @bad_guy.cur_hp = @bad_guy.cur_hp - @dmg_dlt
        end
        if @bad_guy.cur_hp <= 0
          puts "You have slain the #{@bad_guy.name} and won the day!"
          # rewards for winning the battle!
          @player.xp = @player.xp + @bad_guy.xp
          @player.coin = @player.coin + @bad_guy.coin
          save_data
          return
        else
          puts "#{@bad_guy.name} viciously attacks #{@player.name}!"
          puts # formatting
          miss_chance = dice(100)
          agi_boost = (@player.agi-10)*2 + @player.dodge
          if (1..agi_boost).include?(miss_chance)
            puts @player.name + " totally leaps out of the way, avoiding being hit by " + @bad_guy.name + "!"
          else
            dmg_taken = dice(@bad_guy.dmg) - @player.armor/4
            dmg_taken = 0 if dmg_taken < 1
            @player.cur_hp = @player.cur_hp - dmg_taken
            puts "#{@bad_guy.name} hits YOU for #{dmg_taken} damage!" unless dmg_taken < 1
            puts "OUCH!" unless dmg_taken < 1
          end
          puts #formatting
        end
        if @player.cur_hp <= 0
          puts "You were killed by the #{@bad_guy.name}."
          puts "Killed dead."
          player_croaks
        end
      when move == "2"
        puts # formatting
        puts "Sometimes the right thing to do is run."
        puts "This is one of those times."
        puts # formatting
        puts "You shout what is that? and point frantically in the opposite direction."
        puts "The #{@bad_guy.name} turns to look and you high tail it away!"
        puts # formatting
        run_away = dice(10)
        case
        when (1..8).include?(run_away)
        # you got away this time
        puts "You escape from the #{@bad_guy.name} while it foolishly looks away."
        when (9..10).include?(run_away)
        # not so lucky this time
        puts "#{@bad_guy.name} says, do you think I was spawned yesterday?"
        puts # formatting
        puts "#{@bad_guy.name} viciously attacks #{@player.name}!"
        puts # formatting
        miss_chance = dice(100)
        agi_boost = (@player.agi-10)*2 + @player.dodge
        if (1..agi_boost).include?(miss_chance)
          puts @player.name + " totally leaps out of the way, avoiding being hit by " + @bad_guy.name + "!"
        else
          dmg_taken = dice(@bad_guy.dmg) - @player.armor/4
          dmg_taken = 0 if dmg_taken < 1
          @player.cur_hp = @player.cur_hp - dmg_taken
          puts "#{@bad_guy.name} hits YOU for #{dmg_taken} damage!" unless dmg_taken < 1
          puts "OUCH!" unless dmg_taken < 1
        end
        puts #formatting
        if @player.cur_hp <= 0
          puts "You knew when to fold em, but the #{@bad_guy.name} got the better of you anyway."
          player_croaks
        end
        puts "You manage to accidentally stick a boot firmly in the #{@bad_guy.name}'s face"
        puts "allowing you to escape!"
        puts # formatting
        end
        save_data
        return
      end
    end
    
  end
  
  def dice(sides=6,&block)
    if block_given?
      block.call(rand(1..sides))
    else
      rand(1..sides)
    end
  end

  def random_encounter
    chance = dice(20)
    case
    when (1..2).include?(chance)
      puts # formatting
      puts "You get the feeling you are being watched..."
      puts # formatting
    when (3..4).include?(chance)
      puts # formatting
      puts "You notice a coin stuck in the dirt, pry it"
      puts "loose, and place the coin in your wallet."
      puts # formatting
      puts "Today must be your lucky day, #{@player.name}!"
      @player.xp = @player.xp + @player.lvl*100
      @player.coin = @player.coin + @player.lvl*2
      puts # formatting
    when (5..8).include?(chance)
      puts #format
      puts "A small goblin springs from the shadows and attacks!!"
      puts #format
      combat(Goblin)
    when (9..11).include?(chance)
      puts #format
      puts "You hear squeeking sounds. BIG squeeking sounds!"
      puts #format
      combat(GiantRat)
    when (12..15).include?(chance)
      puts #format
      puts "A kobold peers out of a hole in the wall and then snarls."
      puts #format
      combat(Kobold)
    when (16..18).include?(chance)
      puts #format
      puts "Although you have never heard bones scrape across a floor"
      puts "before, you know without a doubt what approaches..."
      puts #format
      combat(Skeleton)
    when (19..20).include?(chance)
      puts # formatting
      trip_event = dice(3)
      trip_part = "knee" if trip_event == 1
      trip_part = "elbow" if trip_event == 2
      trip_part = "hands" if trip_event == 3
      trip_damage = @player.lvl
      puts "You stumble and scrape your #{trip_part}."
      puts "You take #{trip_damage} damage."
      puts # formatting
      @player.cur_hp = @player.cur_hp - trip_damage
      if @player.cur_hp <= 0
        puts "You have tripped and died."
        player_croaks
      end
    end 
  end
  
end