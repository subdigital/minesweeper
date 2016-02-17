require 'rubygems'
require 'gosu'
require 'hasu'
require 'thread'

Hasu.load 'board.rb'
Hasu.load 'led_display.rb'
Hasu.load 'commands.rb'

class Game < Hasu::Window
  attr_reader :board
  attr_reader :mine_display
  attr_reader :command_queue
  attr_reader :voted_commands
  attr_reader :user_votes

  def initialize
    super 1000, 1000, fullscreen: false
    self.caption = "Minesweeper!"
    setup_votes
  end

  def setup_votes
    @voted_commands = {}
    @user_votes = {}
  end

  def needs_cursor?
    true
  end

  def reset
    @board = Board.new(self)
    new_game
  end

  def new_game
    @board.new_game

    @mine_display = LedDisplay.new(3)
    @mine_display.x = board.board_x - board.border_width
    @mine_display.y = board.board_y - @mine_display.height - board.border_width * 2 
    @mine_display.set_number board.mine_count

    @command_queue = Queue.new
  end

  # threadsafe
  def enqueue_command(*cmd)
    @command_queue << cmd
  end

  def chat_select(coordinates)
    return if not board.valid_coordinates?(coordinates)
    board.reveal_at(coordinates)
  end

  def chat_flag(coordinates)
    return if not board.valid_coordinates?(coordinates)

    if board.visible_field[coordinates[:y]][coordinates[:x]] == board.tile_index(:raised)
      flag(coordinates)
    end
  end

  def chat_unflag(coordinates)
    return if not board.valid_coordinates?(coordinates)

    if board.visible_field[coordinates[:y]][coordinates[:x]] == board.tile_index(:flag)
      flag(coordinates)
    end
  end

  def flag(coordinates)
    board.flag_at(coordinates)
    mine_display.set_number [board.mine_count - board.flag_count, 0].max
  end

  def game_over?
    board.game_over
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close

    when Gosu::MsLeft
      if board.game_over
        new_game
      else
        coordinates = board.translate_screen(mouse_x, mouse_y)
        return if coordinates.nil?
        board.reveal_at(coordinates)
      end

    when Gosu::MsRight
        coordinates = board.translate_screen(mouse_x, mouse_y)
        return if coordinates.nil?
        flag(coordinates)
    end
  end

  def update
    process_commands
    if game_over?
      @command_queue.clear
    end
  end

  def process_commands
    cmd = @command_queue.pop(true) rescue nil
    if cmd
      action = cmd.first
      args = cmd.slice(0..-1)
      puts "PROCESSING COMMAND: #{action}  (#{args})"
      # Assuming commands are votes, create a Ballot.
      Ballot.new(self).perform(*args)      
    end
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

  def draw
    draw_background
    board.draw
    mine_display.draw
  end

  def draw_background
    Gosu.draw_rect 0, 0, width, height, Gosu::Color.argb(0xff999999)
  end

  private

end

if $0 == __FILE__
  Game.run
end

