module GameMechanics
  
  @@save_file = 'lib/save_game.json'
  
  def prompt
    print ">> "
  end
  
  def save_data
    save_info = {
      role:   @player.class,
      xp:     @player.xp,
      lvl:    @player.lvl,
      coin:   @player.coin,
      name:   @player.name
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
    @player.xp   = load_info['xp']
    @player.lvl  = load_info['lvl']
    @player.coin = load_info['coin']
    @player.name = load_info['name']
    @player
    # I was trying to do the above assignments with iteration, there has to be a way!
#    load_info.each do |attribute, value|
#      @player.#{attribute} = value unless attribute == "role"
#    end  
  end

  def stat_bar name, xp, lvl, coin, cur_hp, cur_mana
    puts "_"*23 + "   STATS   " + "_"*23
    puts "Name: #{name} | XP: #{xp} | Lvl: #{lvl} | Coin: #{coin} | HP: #{cur_hp} | Mana: #{cur_mana}"
    puts "-"*60
  end
  
end