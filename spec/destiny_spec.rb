require 'destiny'

describe GameSelect do
  
  it "should ask if the player wants a new game and respond appropriately" do
    GameSelect.new("no").outcome.should eq "Loading the existing game."
  end

# Taking this out temporarily until I figure out how to deal with the method wanting user input  
#  it "should ask if the player wants a new game and respond appropriately" do
#    GameSelect.new("yes").outcome.should eq "Starting a new game, please answer the following questions:"
#  end
  
end

describe GameMechanics do
  
  it "should create a top divider bar" do
    bar_top.should eq "_________________________ STATS _________________________"
  end

  it "should return the player's stats" do
    stat_bar("Bagginszz", 50, 1, 3, 4, 24).should eq "Name: Bagginszz | XP: 50 | Lvl: 1 | Coin: 3 | HP: 4 | Mana: 24"
  end

  it "should create a lower divider bar" do
    bar_low.should eq "----------------------------------------------------------"
  end
  
  it "should return a random number between 1 and # of sides" do
    digits = 1..20
    digits.include?(dice(20)).should eq true
  end
  
end
