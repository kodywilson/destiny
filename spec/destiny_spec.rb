require 'destiny'

describe NewGame do
  
  it "should ask the player if they want to start a new game" do
    NewGame.new("yes").game_select.should eq "Starting a new game, please enter character name."
  end
  
end
