module GameMechanics
  
  @@save_file = '../lib/save_game.json'
  
  def prompt
    print ">> "
  end
  
  def save_data
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
    # Set attributes based off information in load_info
    @player.cur_hp   = load_info['cur_hp']
    @player.cur_mana = load_info['cur_mana']
    @player.xp       = load_info['xp']
    @player.lvl      = load_info['lvl']
    @player.coin     = load_info['coin']
    @player.name     = load_info['name']
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
    "_"*25 + " STATS " + "_"*25
  end
  
  def stat_bar name, xp, lvl, coin, cur_hp, cur_mana
    "Name: #{name} | XP: #{xp} | Lvl: #{lvl} | Coin: #{coin} | HP: #{cur_hp} | Mana: #{cur_mana}"
  end
  
  def bar_low
    "-"*58
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
    when (1..5).include?(chance)
      puts # formatting
      puts "You get the feeling you are being watched..."
      puts # formatting
    when (6..10).include?(chance)
      puts #format
      puts "A small goblin springs from the shadows and attacks!!"
      puts #format
    when (11..15).include?(chance)
      puts #format
      puts "You hear squeeking sounds. BIG squeeking sounds!"
      puts #format
    when (16..20).include?(chance)
      puts # formatting
      puts "You step into a puddle of water and angrily lift your boot out."
      puts # formatting
    end 
  end
  
end