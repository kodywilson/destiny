require 'destiny'
require 'choice'
require 'edge_coloring_graph'
require 'dungeon_map'
require 'colorize'

describe GameSelect do

  it "should ask if the player wants a new game and respond appropriately" do
    expect(GameSelect.new("no").outcome).to eq("Loading the existing game.")
  end

end

describe GameMechanics do

  it "should create a top divider bar" do
    expect(bar_top).to eq("___________________________ STATS ___________________________")
  end

  it "should return the player's stats" do
    expect(stat_bar("Bagginszz", 50, 1, 3, 4, 24)).to eq("  Name: Bagginszz | XP: 50 | Lvl: 1 | Coin: 3 | HP: 4 | Mana: 24")
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
    ["Giant Rat", "ROUS", "Nuck Chorris"].include?(GiantRat.new.name).should eq true
  end

  it "should alter stats based on sub type generated" do
    [8,10,12].include?(GiantRat.new.hp).should eq true
  end

end

describe Goblin do

  it "should generate base stats when created" do
    Goblin.new.int.should eq 8
  end

  it "should set name to Goblin or Goblin Warrior" do
    ["Goblin", "Goblin Warrior", "Goblin Chief"].include?(Goblin.new.name).should eq true
  end

  it "should alter stats based on sub type generated" do
    [6,8,10].include?(Goblin.new.hp).should eq true
  end

end

describe Kobold do

  it "should generate base stats when created" do
    Kobold.new.int.should eq 8
  end

  it "should set name to Kobold or Kobold Thief" do
    ["Kobold", "Kobold Thief", "Kobold Berserker"].include?(Kobold.new.name).should eq true
  end

  it "should alter stats based on sub type generated" do
    [6,10].include?(Kobold.new.hp).should eq true
  end

end

describe Skeleton do

  it "should generate base stats when created" do
    Skeleton.new.int.should eq 8
  end

  it "should set name to Skeleton or Skeletal Knight" do
    ["Skeleton", "Skeletal Knight", "Skeleton of Geoff"].include?(Skeleton.new.name).should eq true
  end

  it "should alter stats based on sub type generated" do
    [8, 10].include?(Skeleton.new.hp).should eq true
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
#{"[1] ".yellow}run
#{"[2] ".yellow}hide
    MSG
    choice.should_receive(:puts).with(msg)
    choice.should_receive(:gets).and_return("1\n")
    choice.prompt
  end

  it "should allow me to commands" do
    choice = Choice.new "What will you do when you see a ghost?", {
      '1' => 'run',
      '2' => 'hide'
    }
    choice.add('b', 'befriend')
    msg = <<-MSG
What will you do when you see a ghost?
#{"[1] ".yellow}run
#{"[2] ".yellow}hide
#{"[b] ".yellow}befriend
    MSG
    choice.should_receive(:puts).with(msg)
    choice.should_receive(:gets).and_return("b\n")
    choice.prompt
  end
end

describe EdgeColoringGraph do

  map = <<-MAP
  0 1 2 3 4 5 6 7 8 9
0| | |r| | |w| |c| | |
1| | | | |w|c| | | | |
2|r| | |c| |i| | |w| |
3| | |c| | | |i| | | |
4| |w| | | | | | | | |
5|w|c|i| | | | | | | |
6| | | |i| | | |w| |r|
7|g| | | | | |w| | |i|
8| | |w| | | | | | |c|
9| | | | | | |r|i|c| |
  MAP

  map_arr = map.split("\n")[1..map.length].map {|line| line.split('|')[1..map.length]}

#   it 'should parse the map' do
#     g = EdgeColoringGraph.new map
#     g.edge(0, 2).should eq true
#     g.edge(1, 3).should eq false
#   end
  it 'should give the color of edges' do
    g = EdgeColoringGraph.new map_arr
    g.edge(0, 1).should eq ' '
    g.edge(0, 2).should eq 'r'
    g.edge(2, 3).should eq 'c'
  end
end

describe DungeonMap do

  map = <<-MAP
  0 1 2 3 4 5 6 7 8 9
0| | |r| | |w| |c| | |
1| | | | |w|c| | | | |
2|r| | |c| |i| | |w| |
3| | |c| | | |i| | | |
4| |w| | | | | | | | |
5|w|c|i| | | | | | | |
6| | | |i| | | |w| |r|
7|g| | | | | |w| | |i|
8| | |w| | | | | | |c|
9| | | | | | |r|i|c| |
  MAP

  map_arr = map.split("\n")[1..map.length].map {|line| line.split('|')[1..map.length]}

  dungeon_rooms = [
    {:msg => 'You have entered the dungeon! DUM DUM DUM!!'},
    {:msg => 'You hear rats feet scampering across broken glass.'},
    {:msg => 'You feel a slight draft and your torch flickers briefly...'},
    {:msg => 'You see a wooden coffin locked with a heavy chain.'},
    {:msg => 'The smell of rotting flesh fills you lungs.'},
    {:msg => 'You feel a slight draft and your torch flickers briefly...'},
    {:msg => 'You notice strange markings on the walls. '},
    {:msg => 'You feel a slight draft and your torch flickers briefly...'},
    {:msg => 'More strange markings, they seem to mean something, but what and who wrote them?'},
    {:msg => 'A locked chest sits in the corner.'}
  ]

  it 'should create a Choice' do
    dungeon_map = DungeonMap.new map_arr, dungeon_rooms
    location = 0
    choices = dungeon_map.choices location
    choices.choices.keys.should =~ [:r, :w, :c]
  end

  it 'should allow movement through doors' do
    dungeon_map = DungeonMap.new map_arr, dungeon_rooms
    location = 0
    next_location = dungeon_map.door_to location, :r
    next_location.should be 2
    futher_down_the_road = dungeon_map.door_to next_location, :w
    futher_down_the_road.should be 8

  end

  it 'should ignore invalid movements' do
    dungeon_map = DungeonMap.new map_arr, dungeon_rooms
    location = 0
    next_location = dungeon_map.door_to location, :invalid
    next_location.should be location
  end

  it 'should give me a message for each room' do
    dungeon_map = DungeonMap.new map_arr, dungeon_rooms
    dungeon_map.room(0)[:msg].should eq 'You have entered the dungeon! DUM DUM DUM!!'
    dungeon_map.room(9)[:msg].should eq 'A locked chest sits in the corner.'
  end
end
