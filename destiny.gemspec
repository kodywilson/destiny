Gem::Specification.new do |s|
  s.name         = 'destiny'
  s.version      = '0.0.7'
  s.date         = '2021-03-31'
  s.summary      = "text rpg"
  s.description  = "Role playing game with distinct classes, character development, and a dungeon map!"
  s.authors      = ["Kody Wilson"]
  s.email        = 'kodywilson@gmail.com'
  s.homepage     = 'https://github.com/kodywilson/destiny'
  s.license      = 'MIT'
  s.files        = ["lib/destiny.rb", "lib/mobs.rb", "lib/places.rb", "lib/game_mechanics.rb", "lib/choice.rb" , "lib/edge_coloring_graph.rb", "lib/dungeon_map.rb"]
  s.executables  = ["destiny"]
  s.add_runtime_dependency 'colorize', '~> 0.8.0', '>= 0.8.0'
end
