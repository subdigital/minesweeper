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

  def initialize
    super 1000, 1000, fullscreen: false
    self.caption = "Minesweeper!"
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

Game.run if $0 == __FILE__
