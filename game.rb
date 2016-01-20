require 'rubygems'
require 'gosu'
require 'hasu'

Hasu.load 'board.rb'

class Game < Hasu::Window
  attr_reader :board

  def initialize
    super 1000, 1000, fullscreen: false
    self.caption = "Minesweeper!"
  end

  def needs_cursor?
    true
  end

  def reset
    @board = Board.new(self)
    @board.new_game
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close

    when Gosu::MsLeft
      board.reveal_at mouse_x, mouse_y

    when Gosu::MsRight
      # @board.flag_at mouse_x, mouse_y
    end
  end

  def draw
    draw_background
    board.draw
  end

  def draw_background
    Gosu.draw_rect 0, 0, width, height, Gosu::Color.argb(0xff999999)
  end

  private

end

Game.run
