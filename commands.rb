class VoteCommand
	def initialize(game, args)
		puts "initialized vote command with args #{args}"
		@game = game
		@args = args
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

	def perform
	end

	def self.identifier(args)
		args[0].to_s + args.slice(1..-1).to_s
	end
end

class VoteSweepCommand < VoteCommand
  def perform(coordinates)
    return if not @game.board.valid_coordinates?(coordinates)
    @game.board.reveal_at(coordinates)
  end
end

class Ballot
	def initialize(game)
		@game = game
	end

	def perform(*args)
		puts "Ballot args #{args}"
		puts args[1]
		@game.vote(* args)
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