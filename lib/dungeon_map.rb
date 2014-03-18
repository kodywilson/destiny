require 'edge_coloring_graph'
require 'choice'

DoorNames = {
  :w => 'wooden door',
  :i => 'iron door',
  :c => 'crack in the wall',
  :r => 'rusty door'
}

class DungeonMap
  def initialize map
    @map = map
  end

  def door_to current_location, command
    doors = doors_at current_location
    if doors[command]
      return doors[command]
    else
      return current_location
    end
  end

  def choices location
    doors = doors_at location
    door_choices = {}
    doors.keys.each do |command|
      door_choices[command.to_sym] = "Go through the #{DoorNames[command]}."
    end
    Choice.new 'Where will you go next?', door_choices
  end

  def doors_at location
    doors = {}
    @map[location].each_with_index do |door, next_room|
      doors[door.to_sym] = next_room if door != ' '
    end
    doors
  end
end
