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
  end

  def draw
    draw_background
    board.draw
  end

  def draw_background
    Gosu.draw_rect 0, 0, width, height, Gosu::Color.argb(0xff888888)
  end

  private

end

Game.run
