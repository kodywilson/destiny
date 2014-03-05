class Mobs

  attr_accessor :str, :agi, :int, :damage_dealt, :armor, :hp, :dodge, :mana
  
  def initialize(str, agi, int, damage_dealt, armor, hp, dodge, mana, name="MOB")
    @str          = str
    @agi          = agi
    @int          = int
    @damage_dealt = damage_dealt
    @armor        = armor
    @hp           = hp
    @dodge        = dodge
    @mana         = mana
    @name         = name
    
  end
  
end

class Knight < Mobs

  def initialize(str=14, agi=12, int=8, damage_dealt=6, armor=10, hp=8, dodge=20, mana=8, name="Knight")
    super(str,agi,int,damage_dealt,armor,hp,dodge,mana,name)
    @name = name
  end
  
  def name
    @name
  end

end

class Wizard < Mobs

  def initialize(str=8, agi=10, int=16, damage_dealt=3, armor=4, hp=4, dodge=10, mana=24, name="Wizard")
    super(str,agi,int,damage_dealt,armor,hp,dodge,mana,name)
    @name = name
  end
  
  def name
    @name
  end

end

class Goblin < Mobs

  def initialize(str=12, agi=10, int=8, damage_dealt=3, armor=6, hp=3, dodge=20, mana=2, name="Goblin")
    super(str,agi,int,damage_dealt,armor,hp,dodge,mana,name)
  end

end
