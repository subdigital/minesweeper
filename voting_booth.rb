require 'timers'
timers = Timers::Group.new

class VotingBooth
	def initialize
		every_five_seconds = timers.every(5) { puts "Another 5 seconds" }
	end
end