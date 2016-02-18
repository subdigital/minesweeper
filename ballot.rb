class Ballot
	attr_reader :voted_commands
  attr_reader :user_votes

	def initialize
		@voted_commands = {}
    @user_votes = {}
	end

	def vote(* args)
    username = args[2]

    puts "VOTING #{args}"
    puts "Username: #{username}"

    previous_vote = @user_votes[username]
    if previous_vote
      @voted_commands[previous_vote].remove_vote username
    end

    # assign their new vote
    command_identifier = VoteCommand.identifier(args.slice(0..-2))
    @user_votes[username] = command_identifier

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
        vote = command_class.new(args.slice(1..-1))
        @voted_commands[command_identifier] = vote
      end

      puts "added to @voted_commands"
    end

    puts "voted commands #{@voted_commands}"

  end

  def elect(game)
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

		puts "The highest commands are #{highest_commands.count} #{highest_commands}"

  end

end