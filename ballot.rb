class Ballot
	attr_reader :voted_commands
  attr_reader :user_votes

	def initialize
		reset_votes
	end

	def reset_votes
		@voted_commands = {}
    @user_votes = {}
  end

	def vote(* args, game)
    username = args[2]

    puts "VOTING #{args}"
    puts "Username: #{username}"

    previous_vote = @user_votes[username]
    if previous_vote
      @voted_commands[previous_vote].remove_vote username
    end

    # assign their new vote
    command_identifier = VoteCommand.identifier(args.slice(0..-2))

    puts "command identifier" + command_identifier
    existing_command = @voted_commands[command_identifier]
    
    if existing_command
      existing_command.add_vote username
    else
      command_map = {
        :sweep => VoteSweepCommand
      }

      command_class = command_map[args[0]]
      if command_class
      	puts args[1]
      	if not command_class.valid_coordinates?(game, args[1])
      		puts "INVALID COORDINATES for #{args}"
      		return
      	end

      	@user_votes[username] = command_identifier

        vote = command_class.new(args.slice(1..-1))
        @voted_commands[command_identifier] = vote
      end

      puts "added to @voted_commands"
    end

    puts "voted commands #{@voted_commands}"

  end

  def elect(game)
    game.new_game and return if game.game_over?
    
  	return if @voted_commands.empty?

  	highest_commands = []
		@voted_commands.each do |identifier, command|
			if highest_commands.count == 0
				highest_commands = [command]
			elsif command.voters.count > highest_commands.first.voters.count
				highest_commands = [command]
			elsif command.voters.count == highest_commands.first.voters.count
				highest_commands.push(command)
			end
		end

		index = rand(0...highest_commands.length)
		highest_commands[index].perform(game)

		reset_votes
  end

end