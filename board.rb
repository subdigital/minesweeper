class Board

  SOURCE_TILE_SIZE = 16
  SCALE_FACTOR = 4
  TILE_SIZE = SOURCE_TILE_SIZE * SCALE_FACTOR

  TILE_POSITIONS = [
    :blank,
    :one,
    :two,
    :three,
    :four,
    :five,
    :six,
    :seven,
    :eight,
    :raised,
    :flag,
    :mine,
    :red_mine,
    :x_mine
  ]

  attr_reader :window
  attr_reader :sprite_sheet
  attr_reader :field

  def initialize(window)
    @window = window
    @num_tiles = 10
    _load_tiles
  end

  def new_game
    @field = generate_field
  end

  def reveal_at(sx, sy)
    board_coords = translate_screen(sx, sy)
    return if board_coords.nil?
  end

  def draw
    draw_border
    draw_tiles
  end

  def draw_border
    line_width = 2 * SCALE_FACTOR
    x = board_x - line_width
    y = board_y - line_width
    w = width + line_width + SCALE_FACTOR
    h = height + line_width + SCALE_FACTOR
    c = Gosu::Color.argb(0xff555555)
    Gosu.draw_rect x, y, w, line_width, c
    Gosu.draw_rect x, y, line_width, h, c
    Gosu.draw_rect x + w, y, line_width, h, c

    Gosu.draw_rect x, y + h, w+line_width, line_width, c

    Gosu.draw_rect x, y + h, w+line_width, line_width, c
  end

  def draw_tiles
    @num_tiles.times do |y|
      @num_tiles.times do |x|
        tile_index = field[y][x]
        tile = sprite_sheet[tile_index]
        tile.draw board_x + x*TILE_SIZE, board_y + y*TILE_SIZE, 0, SCALE_FACTOR, SCALE_FACTOR
      end
    end

    # draw right/bottom lines b/c they aren't in the sprites
    right_x = board_x + width
    y = board_y
    lw = 1 * SCALE_FACTOR
    c = Gosu::Color.argb(0xff808080)
    Gosu.draw_rect(right_x, y, lw, height, c)
    Gosu.draw_rect(board_x, y + height, width + lw, lw, c)
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

  def translate_screen(x, y)
    return nil if x < board_x || x > (board_x + width)
    return nil if y < board_y || y > (board_y + height)
    relative_x = x - board_x
    relative_y = y - board_y
    [
      (relative_x / TILE_SIZE).floor,
      (relative_y / TILE_SIZE).floor
    ]
  end

  def generate_field
    @num_tiles.times.map {
      @num_tiles.times.map { TILE_POSITIONS.find_index(TILE_POSITIONS.sample) }
    }
  end
end
