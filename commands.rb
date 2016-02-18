class VoteCommand
	def initialize(args)
		puts "initialized vote command with args #{args}"
		@coordinates = args[0]
		@voters = [args[1]]

		puts "Vote command has voters #{@voters}"
	end

	def add_vote(username)
		return if @voters.include? username
		@voters.push(username)
	end

	def remove_vote(username)
		@voters.delete(username)
	end

	def votes
		@voters.count
	end

	def perform(game)
	end

	def self.identifier(args)
		args[0].to_s + args.slice(1..-1).to_s
	end
end

class VoteSweepCommand < VoteCommand
  def perform(game)
    return if not game.board.valid_coordinates?(@coordinates)
    game.board.reveal_at(@coordinates)
  end
end

# class SweepCommand
#   def initialize(game)
#     @game = game
#   end

#   def perform(coordinates)
#     return if not @game.board.valid_coordinates?(coordinates)
#     @game.board.reveal_at(coordinates)
#   end
# end