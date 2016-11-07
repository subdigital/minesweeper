class VoteCommand
  attr_reader :voters

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

	def self.valid_coordinates?(game, coords)
		game.board.valid_coordinates?(coords)
	end
end

class VoteSweepCommand < VoteCommand
  def perform(game)
    return if not game.board.valid_coordinates?(@coordinates)
    game.board.reveal_at(@coordinates)
  end

  def self.valid_coordinates?(game, coords)
  	puts "GAME #{game}"
  	puts "COORDS #{coords.class}"
  	super && game.board.playable_coordinates?(coords)
  end
end
