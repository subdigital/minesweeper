require 'Hasu'
Hasu.load 'game.rb'
g = Game.new
g.enqueue_command :sweep, {:x => 5, :y => 5}, 'qp'
g.process_commands