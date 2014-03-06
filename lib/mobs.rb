class Mobs

  attr_accessor :str, :agi, :int, :dmg, :armor, :hp, :cur_hp, :dodge, :mana, :cur_mana, :xp, :lvl, :coin, :name
  
  def initialize(str, agi, int, dmg, armor, hp, cur_hp, dodge, mana, cur_mana, xp, lvl, coin, name="MOB")
    @str          = str
    @agi          = agi
    @int          = int
    @dmg          = dmg
    @armor        = armor
    @hp           = hp
    @cur_hp       = cur_hp
    @dodge        = dodge
    @mana         = mana
    @cur_mana     = cur_mana
    @xp           = xp
    @lvl          = lvl
    @coin         = coin
    @name         = name
  end
  
end

class Knight < Mobs

  def initialize(str=14, agi=12, int=8, dmg=6, armor=10, hp=8, cur_hp=8, dodge=20, mana=8, cur_mana=8, xp=0, lvl=1, coin=0, name="Knight")
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end

class Wizard < Mobs

  def initialize(str=8, agi=10, int=16, dmg=3, armor=4, hp=4, cur_hp=4, dodge=10, mana=24, cur_mana=24, xp=0, lvl=1, coin=0, name="Wizard")
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end

class Goblin < Mobs

  def initialize(str=10, agi=10, int=8, dmg=3, armor=6, hp=3, cur_hp=3, dodge=20, mana=2, cur_mana=2, xp=0, lvl=1, coin=0, name="Goblin")
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end

class GiantRat < Mobs

  def initialize(str=12, agi=10, int=4, dmg=3, armor=6, hp=3, cur_hp=3, dodge=10, mana=0, cur_mana=0, xp=0, lvl=1, coin=0, name="ROUS")
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end
