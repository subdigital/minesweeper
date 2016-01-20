class Board

  SOURCE_TILE_SIZE = 16
  SCALE_FACTOR = 4
  TILE_SIZE = SOURCE_TILE_SIZE * SCALE_FACTOR

  attr_reader :window
  attr_reader :sprite_sheet

  def initialize(window)
    @window = window
    @num_tiles = 10
    _load_tiles
  end

  def draw
    draw_border
    draw_tiles
  end

  def draw_border
    line_width = 2 * SCALE_FACTOR
    x = board_x - line_width
    y = board_y - line_width
    w = width + line_width
    h = height + line_width
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

  def _load_tiles
    @sprite_sheet = Gosu::Image.load_tiles 'assets/tiles.png',
      SOURCE_TILE_SIZE,
      SOURCE_TILE_SIZE,
      retro: true
  end

  def board_x
    (window.width - width) / 2.0
  end

  def board_y
    (window.height - height) / 2.0
  end

  def width
    @num_tiles * TILE_SIZE
  end

  def height
    @num_tiles * TILE_SIZE
  end

end
