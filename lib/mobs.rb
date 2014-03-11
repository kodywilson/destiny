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

# playable character roles
# each role will have a focus, like healing or magic spells

class Cleric < Mobs
  # clerics can heal themselves, and even put their HP's above max during combat, as a buffer
  def initialize(str=12, agi=12, int=10, dmg=5, armor=8, hp=6, cur_hp=6, dodge=5, mana=12, cur_mana=12, xp=0, lvl=1, coin=0, name="Cleric")
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end

class Knight < Mobs
  # the knight has the highest melee damage, strength, and armor
  def initialize(str=14, agi=12, int=8, dmg=6, armor=10, hp=8, cur_hp=8, dodge=10, mana=8, cur_mana=8, xp=0, lvl=1, coin=0, name="Knight")
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end

class Rogue < Mobs
  # rogues have good melee damage and the highest dodge, they get extra coin too :)
  def initialize(str=12, agi=16, int=12, dmg=6, armor=6, hp=6, cur_hp=6, dodge=20, mana=0, cur_mana=0, xp=0, lvl=1, coin=0, name="Rogue")
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end

class Wizard < Mobs
  # wizards can cast damaging spells
  def initialize(str=8, agi=10, int=16, dmg=4, armor=4, hp=4, cur_hp=4, dodge=5, mana=16, cur_mana=16, xp=0, lvl=1, coin=0, name="Wizard")
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end

# Opponents below

class GiantRat < Mobs

  def initialize(str=12, agi=10, int=4, dmg=5, armor=6, hp=8, cur_hp=8, dodge=5, mana=0, cur_mana=0, xp=150, lvl=1, coin=1, name="Giant Rat")
    rat_type = dice(10)
    case
    when (1..8).include?(rat_type)
      # no change, you just get the generic giant rat
    when (9..10).include?(rat_type)
      # this feller is much harder to defeat
      str      = 16
      dmg      = 8
      hp       = 10
      cur_hp   = 10
      xp       = 400
      coin     = 3
      name     = "ROUS"
    end
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end

class Goblin < Mobs

  def initialize(str=10, agi=10, int=8, dmg=4, armor=6, hp=6, cur_hp=6, dodge=15, mana=2, cur_mana=2, xp=100, lvl=1, coin=1, name="Goblin")
    # Should probably create a method that does the below
    goblin_type = dice(10)
    case
    when (1..6).include?(goblin_type)
      # no change, you just get the generic goblin
    when (7..10).include?(goblin_type)
      # this feller is stronger, but less nimble
      str      = 16
      dmg      = 6
      armor    = 8
      hp       = 8
      cur_hp   = 8
      dodge    = 10
      xp       = 200
      coin     = 2
      name     = "Goblin Warrior"
    end
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end

class Kobold < Mobs

  def initialize(str=12, agi=8, int=8, dmg=5, armor=5, hp=6, cur_hp=6, dodge=10, mana=2, cur_mana=2, xp=150, lvl=1, coin=2, name="Kobold")
    kobold_type = dice(10)
    case
    when (1..6).include?(kobold_type)
      # no change, you just get the generic kobold
    when (7..10).include?(kobold_type)
      # this one has double the chance to dodge as a regular kobold
      agi      = 16
      dmg      = 6
      armor    = 6
      hp       = 8
      cur_hp   = 8
      dodge    = 20
      xp       = 300
      coin     = 4
      name     = "Kobold Thief"
    end
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end

class Skeleton < Mobs

  def initialize(str=12, agi=10, int=8, dmg=5, armor=6, hp=8, cur_hp=8, dodge=5, mana=0, cur_mana=0, xp=200, lvl=1, coin=3, name="Skeleton")
    skeleton_type = dice(10)
    case
    when (1..7).include?(skeleton_type)
      # no change, you just get the generic skeleton
    when (8..10).include?(skeleton_type)
      # this feller is considerably tougher
      str      = 16
      dmg      = 6
      armor    = 8
      hp       = 10
      cur_hp   = 10
      xp       = 300
      coin     = 5
      name     = "Skeletal Knight"
    end
    super(str,agi,int,dmg,armor,hp,cur_hp,dodge,mana,cur_mana,xp,lvl,coin,name)
  end

end
