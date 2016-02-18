require 'rubygems'
require 'gosu'
require 'hasu'
require 'thread'
require 'timers'

Hasu.load 'game.rb'
Hasu.load 'ballot.rb'

class ChatGame < Game
	 attr_reader :vote_timer_display

	def initialize
		super
		@ballot = Ballot.new
    @timers = Timers::Group.new
    @foo = 20
    @timers.every(1) { iterate_timer }
	end

	def iterate_timer
    @foo = @foo - 1
    @foo = 20 if @foo <= 0
    @vote_timer_display.set_number @foo
  end

	def update
		super
		@timers.wait
	end

	def new_game
		super
		@command_queue = Queue.new

		@vote_timer_display = LedDisplay.new(2)
    @vote_timer_display.x = board.board_x + 5 * board.border_width
    @vote_timer_display.y = board.board_y + board.height + @mine_display.height + board.border_width * 2 
    @vote_timer_display.set_number 20
	end

	def draw
		super
		vote_timer_display.draw
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
end