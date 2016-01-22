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

  def chat_select(coordinates)
    if not board.valid_coordinates?(coordinates)
      puts "invalid coordinates"
    end
    board.reveal_at(coordinates)
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close

    when Gosu::MsLeft
      if board.game_over
        board.new_game
      else
        coordinates = board.translate_screen(mouse_x, mouse_y)
        return if coordinates.nil?
        board.reveal_at(coordinates)
      end
      
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
