require 'rubygems'
require 'gosu'
require 'hasu'

class Game < Hasu::Window
  attr_reader :sprite_sheet
  attr_reader :board

  SOURCE_TILE_SIZE = 16
  SCALE_FACTOR = 4
  TILE_SIZE = SOURCE_TILE_SIZE * SCALE_FACTOR

  def initialize
    super 1000, 1000, fullscreen: false
    self.caption = "Minesweeper!"
  end

  def needs_cursor?
    true
  end

  def reset
    @num_tiles = 10
    _load_tiles
  end

  def draw
    Gosu.draw_rect 0, 0, width, height, Gosu::Color.argb(0xff888888)
    draw_border
    draw_tiles
  end

  def draw_border
    line_width = 2 * SCALE_FACTOR
    x = board_x - line_width
    y = board_y - line_width
    w = board_width + line_width
    h = board_height + line_width
    c = Gosu::Color.argb(0xff555555)
    Gosu.draw_rect x, y, w, line_width, c
    Gosu.draw_rect x, y, line_width, h, c
    Gosu.draw_rect x + w, y, line_width, h, c
    Gosu.draw_rect x, y + h, w+line_width, line_width, c
  end

  def draw_tiles
    tile = sprite_sheet[9]

    @num_tiles.times do |y|
      @num_tiles.times do |x|
        tile.draw board_x + x*TILE_SIZE, board_y + y*TILE_SIZE, 0, SCALE_FACTOR, SCALE_FACTOR
      end
    end
  end


  private

  def _load_tiles
    @sprite_sheet = Gosu::Image.load_tiles 'assets/tiles.png',
      SOURCE_TILE_SIZE,
      SOURCE_TILE_SIZE,
      retro: true
  end

  def board_x
    (width - board_width) / 2.0
  end

  def board_y
    (height - board_height) / 2.0
  end

  def board_width
    @num_tiles * TILE_SIZE
  end

  def board_height
    @num_tiles * TILE_SIZE
  end
end

Game.run
