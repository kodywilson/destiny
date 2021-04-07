module GameMechanics

  # Set app path
  APP_PATH = if File.exist?(Dir.home)
    File.join(Dir.home, ".destiny")
  else
    abort "User home directory does not seem to be present."
  end
  SAVES = File.join(APP_PATH, "saves")
  Dir.mkdir(SAVES) unless File.exist?(SAVES)

  @@save_file = File.join(APP_PATH, "save_game.json")

  def prompt
    print ">> "
  end

  def yes_no
    #restrict input to valid answers, but don't worry about case
    begin
      puts "Please enter [yes] or [no]:"
      prompt; @yes_no = STDIN.gets.chomp.downcase
    end while not (@yes_no == "yes" or @yes_no == "no")
  end

  def save_data
    # increase level as player gets more xp!
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
    when (15001..19000).include?(@player.xp)
      @player.lvl = 7
    when (19001..24000).include?(@player.xp)
      @player.lvl = 8
    when (24001..29000).include?(@player.xp)
      @player.lvl = 9
    when @player.xp > 29000
      @player.lvl = 10
    end
    save_info = {
      role:       @player.class,
      cur_hp:     @player.cur_hp,
      cur_mana:   @player.cur_mana,
      xp:         @player.xp,
      lvl:        @player.lvl,
      coin:       @player.coin,
      buff_food:  @player.buff_food,
      buff_drink: @player.buff_drink,
      spell_buff: @player.spell_buff,
      name:       @player.name
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
    elsif role == "Cleric"
      @player = Cleric.new
    elsif role == "Rogue"
      @player = Rogue.new
    end
    # Set stats based off information in load_info
    @player.lvl        = load_info['lvl']
    @player.xp         = load_info['xp']
    @player.coin       = load_info['coin']
    @player.name       = load_info['name']
    @player.cur_hp     = load_info['cur_hp']
    @player.cur_mana   = load_info['cur_mana']
    @player.buff_food  = load_info['buff_food']
    @player.buff_drink = load_info['buff_drink']
    @player.spell_buff = load_info['spell_buff']
    # Adjust stats based off of player level
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
    # heal the player when they choose to rest in the tavern
    @player.cur_hp   = @player.hp
    @player.cur_mana = @player.mana
    save_data
  end

  def bar_top
    "_"*27 + " " + "STATS" + " " + "_"*27
  end

  def stat_bar name, xp, lvl, coin, cur_hp, cur_mana
    "  Name: " + "#{name}" + " | XP: #{xp} | Lvl: #{lvl} | Coin: #{coin} | HP: #{cur_hp} | Mana: #{cur_mana}"
  end

  def bar_low
    "-"*61
  end

  def is_even?(x)
    x % 2 == 0 ? true : false
  end

  def player_croaks
    puts # formatting
    if @player.class.to_s == "Wizard" and @player.spell_buff == true
      puts "A single tear falls from Draco as he fades away..."
      puts #formatting
      @player.spell_buff = false
    end
    puts "It happens to the best of us #{@player.name}."
    puts "Fortunately for you, the game of Destiny never ends."
    puts "The game will exit now and you can restart in town."
    puts # formatting
    puts "Better luck next time, eh?"
    @player.buff_food = false
    @player.buff_drink = false
    @player.cur_hp = @player.hp/2
    save_data
    exit
  end

  def combat bad_guy
    # create an opponent
    @bad_guy = bad_guy.new
    # scale power of opponent to level of player
    @bad_guy.cur_hp       = @bad_guy.hp*@player.lvl
    @bad_guy.cur_mana     = @bad_guy.mana*@player.lvl
    @bad_guy.dmg          = @bad_guy.dmg*@player.lvl
    puts @bad_guy.name + " says, you kill my father, now you will die!!" unless (@bad_guy.name == "Giant Rat" or @bad_guy.name == "Skeleton")
    move = 0
    until move == "2"
      begin
        @heal = false
        puts # formatting
        puts bar_low + "--"
        puts " #{@player.name} - HP: #{@player.cur_hp} - Mana: #{@player.cur_mana} |".green + " - VS - " + "| #{@bad_guy.name} - HP: #{@bad_guy.cur_hp} - Mana: #{@bad_guy.cur_mana}".red
        puts bar_low + "--"
        puts # formatting
        choice_opts = {
          "1" => "Attack.",
          "2" => "Run."
        }
        choice_opts["3"] = "Cast Heal and Attack." if @player.class.to_s == "Cleric"
        c = Choice.new "#{@bad_guy.name} vs. #{@player.name}, what will you do?", choice_opts
        move = c.prompt
        move = "4" if move == "3" and @player.class.to_s != "Cleric"
      end while not (move == "1" or move == "2" or move == "3")
      @heal = true if move == "3" # set cleric heal flag to true
      move = "1" if move == "3" # now that flag is set, set move to 1 for the attack part
      case
      when move == "1"
        puts # formatting
        if @player.class.to_s == "Knight"
          puts "#{@player.name} swings the mighty sword at the #{@bad_guy.name}!"
          puts # formatting
          dmg_mod = (@player.str-10)/2 # knights use their str for damage mod
          @dmg_dlt = dice(@player.dmg) + dmg_mod
        elsif @player.class.to_s == "Wizard"
          begin
            choice_opts = { "1" => "one dart" }
            choice_opts["2"] = "two darts"   if @player.cur_mana - 2*@player.lvl >= 0
            choice_opts["3"] = "three darts" if @player.cur_mana - 3*@player.lvl >= 0
            c = Choice.new "How many magic darts will you shoot?", choice_opts
            darts = c.prompt.to_i
            darts = 4 if darts == 2 and @player.cur_mana - 2*@player.lvl < 0
            darts = 4 if darts == 3 and @player.cur_mana - 3*@player.lvl < 0
          end while not (darts == 1 or darts == 2 or darts == 3)
          puts # formatting
          puts "#{@player.name} conjures #{darts} magic dart that zips toward the #{@bad_guy.name}." if darts == 1
          puts "#{@player.name} conjures #{darts} magic darts that zip toward the #{@bad_guy.name}." if darts > 1
          dmg_mod = (@player.int-10)/2 # wizards use their int for damage mod
          @dmg_dlt = dice(@player.dmg) + darts*@player.lvl + dmg_mod# more darts more damage, scales with level
          @player.cur_mana = @player.cur_mana - darts*@player.lvl # more darts more mana spent, scales with level
          # prevent negative mana, but always allow wizard to shoot at least one dart, no matter what
          @player.cur_mana = 0 if @player.cur_mana < 0
        elsif @player.class.to_s == "Cleric"
          if @heal == true
            heal_bonus = 0
            if @player.cur_mana - @player.lvl*2 >= 0
              heal_bonus = dice(4)*@player.lvl
              @player.cur_mana = @player.cur_mana - @player.lvl*2
            end
            @heal_amount = dice(2)*@player.lvl + heal_bonus + 1 # testing with the +1, what I am going for here
                                                                # is to balance the heal with their lower damage and hp
            puts "Praying intently, you add " + "#{@heal_amount}".green + " health points as you prepare to strike."
            @player.cur_hp = @player.cur_hp + @heal_amount
            puts "#{@player.name}, any health points above your normal maximum will fade after combat." if @player.cur_hp > @player.hp
            puts # formatting
          end
          puts "#{@player.name} brings the holy mace thundering down upon #{@bad_guy.name}!"
          puts # formatting
          dmg_mod = (@player.str-10)/2 # clerics use their str for damage mod
          @dmg_dlt = dice(@player.dmg) + dmg_mod
        elsif @player.class.to_s == "Rogue"
          puts "#{@player.name} whirls the razor daggers and strikes at #{@bad_guy.name}!"
          puts # formatting
          dmg_mod = (@player.str-10)/2 + (@player.agi-10)/2 # rogues use their str AND agi for damage mod to help
          @dmg_dlt = dice(@player.dmg) + dmg_mod            # make up for lower armor and health points
        end
        miss_chance = dice(100)
        agi_boost = (@bad_guy.agi-10)*2 + @bad_guy.dodge
        if (1..agi_boost).include?(miss_chance)
          puts # formatting
          puts @bad_guy.name + " jumps out of the way, avoiding being hit by " + @player.name + "!"
          puts # formatting
        else
          @dmg_dlt = @dmg_dlt - @bad_guy.armor/4
          @dmg_dlt = 0 if @dmg_dlt < 1
          puts #formatting
          puts "You deal " + "#{@dmg_dlt}".green + " damage to the #{@bad_guy.name}." unless @dmg_dlt < 1
          puts # formatting
          @bad_guy.cur_hp = @bad_guy.cur_hp - @dmg_dlt
        end
        if @bad_guy.cur_hp <= 0
          puts "You have slain the #{@bad_guy.name} and won the day!"
          # rewards for winning the battle!
          @player.xp = @player.xp + @bad_guy.xp
          if @player.class.to_s == "Rogue"
            @player.coin = @player.coin + @bad_guy.coin + @player.lvl # rogues get bonus cash
          else
            @player.coin = @player.coin + @bad_guy.coin
          end
          @player.cur_hp = @player.hp if @player.cur_hp > @player.hp # this is done to remove extra hp from cleric
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
            if @player.class.to_s == "Wizard" and @player.spell_buff == true and dmg_taken > 1
              draco_helps = @player.lvl + @player.lvl/2 # Trying a bump in mitigation as Wizard is squishy!
              dmg_taken = dmg_taken - draco_helps
              puts "Draco helps shield you absorbing some of the potential damage."
              puts # formatting
            end
            dmg_taken = 0 if dmg_taken < 1
            @player.cur_hp = @player.cur_hp - dmg_taken
            if dmg_taken > 0
              puts "#{@bad_guy.name} hits YOU for " + "#{dmg_taken}".red + " damage!"
              puts "OUCH!"
            else
              puts "You deflect the blow and take no damage."
            end
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
        run_away = dice(15) if @player.class.to_s == "Rogue" # rogues have a higher chance of getting away
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
            puts "#{@bad_guy.name} hits YOU for " + "#{dmg_taken}".red + " damage!" unless dmg_taken < 1
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
        when (11..15).include?(run_away)
          # only a rogue could be so lucky
          puts "Ah, the life of a rogue, so free, so evasive!"
          puts "#{@player.name}, using your roguish powers you slip away unseen, leaving"
          puts "#{@bad_guy.name} cursing and muttering in the dark."
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
      puts "There is a sudden chill in the air and you hear scraping sounds."
      puts "You know without a doubt what approaches..."
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
      save_data
    end
  end

end
