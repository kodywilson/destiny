require 'destiny'
require 'choice'

describe GameSelect do

  it "should ask if the player wants a new game and respond appropriately" do
    GameSelect.new("no").outcome.should eq "Loading the existing game."
  end

end

describe GameMechanics do

  it "should create a top divider bar" do
    bar_top.should eq "___________________________ STATS ___________________________"
  end

  it "should return the player's stats" do
    stat_bar("Bagginszz", 50, 1, 3, 4, 24).should eq "  Name: Bagginszz | XP: 50 | Lvl: 1 | Coin: 3 | HP: 4 | Mana: 24"
  end

  it "should create a lower divider bar" do
    bar_low.should eq "-------------------------------------------------------------"
  end

  it "should return a random number between 1 and # of sides" do
    digits = 1..20
    digits.include?(dice(20)).should eq true
  end

end

describe Cleric do

  it "should generate base stats when created" do
    Cleric.new.cur_mana.should eq 12
  end

  it "should set food and drink buffs to false on new" do
    (Cleric.new.buff_food and Cleric.new.buff_drink).should eq false
  end

  it "should set buffs to false upon initializing" do
    Cleric.new.spell_buff.should eq false
  end

end

describe Knight do

  it "should generate base stats when created" do
    Knight.new.cur_mana.should eq 8
  end

  it "should set food and drink buffs to false on new" do
    (Knight.new.buff_food and Knight.new.buff_drink).should eq false
  end

  it "should set buffs to false upon initializing" do
    Knight.new.spell_buff.should eq false
  end

end

describe Rogue do

  it "should generate base stats when created" do
    Rogue.new.cur_mana.should eq 0
  end

  it "should set food and drink buffs to false on new" do
    (Rogue.new.buff_food and Rogue.new.buff_drink).should eq false
  end

  it "should set buffs to false upon initializing" do
    Rogue.new.spell_buff.should eq false
  end

end

describe Wizard do

  it "should generate base stats when created" do
    Wizard.new.cur_mana.should eq 16
  end

  it "should set food and drink buffs to false on new" do
    (Wizard.new.buff_food and Wizard.new.buff_drink).should eq false
  end

  it "should set buffs to false upon initializing" do
    Wizard.new.spell_buff.should eq false
  end

end

describe GiantRat do

  it "should generate base stats when created" do
    GiantRat.new.int.should eq 4
  end

  it "should set name to Giant Rat or ROUS" do
    ["Giant Rat", "ROUS"].include?(GiantRat.new.name).should eq true
  end

  it "should alter stats based on sub type generated" do
    [8,10].include?(GiantRat.new.hp).should eq true
  end

end

describe Goblin do

  it "should generate base stats when created" do
    Goblin.new.int.should eq 8
  end

  it "should set name to Goblin or Goblin Warrior" do
    ["Goblin", "Goblin Warrior"].include?(Goblin.new.name).should eq true
  end

  it "should alter stats based on sub type generated" do
    [6,8].include?(Goblin.new.hp).should eq true
  end

end

describe Kobold do

  it "should generate base stats when created" do
    Kobold.new.int.should eq 8
  end

  it "should set name to Kobold or Kobold Thief" do
    ["Kobold", "Kobold Thief"].include?(Kobold.new.name).should eq true
  end

  it "should alter stats based on sub type generated" do
    [6,8].include?(Kobold.new.hp).should eq true
  end

end

describe Skeleton do

  it "should generate base stats when created" do
    Skeleton.new.int.should eq 8
  end

  it "should set name to Skeleton or Skeletal Knight" do
    ["Skeleton", "Skeletal Knight"].include?(Skeleton.new.name).should eq true
  end

  it "should alter stats based on sub type generated" do
    [8, 10].include?(Skeleton.new.hp).should eq true
  end

end


def fake_stdin(*args)
  begin
    $stdin = StringIO.new
    $stdin.puts(args.shift) until args.empty?
    $stdin.rewind
    yield
  ensure
    $stdin = STDIN
  end
end

describe Choice do
  it "should prompt user with choices" do
    choice = Choice.new "What will you do when you see a ghost?", {
      '1' => 'run',
      '2' => 'hide'
    }
    msg = <<-MSG
What will you do when you see a ghost?
[1] run
[2] hide
    MSG
    fake_stdin("1\n") do
      STDOUT.should_receive(:puts).with(msg)
      answer = choice.prompt
      answer.should eq "1"
    end
  end

end
