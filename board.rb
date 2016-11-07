class Board

  SOURCE_TILE_SIZE = 16
  SCALE_FACTOR = 1
  TILE_SIZE = SOURCE_TILE_SIZE * SCALE_FACTOR
  MAX_DIFFICULTY = 7
  DIFFICULTY_SCALE = 0.05
  MINIMUM_DIFICULTY_SCALE = 0.1

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
  attr_reader :visible_field
  attr_reader :game_over
  attr_reader :difficulty

  def initialize(window)
    @window = window
    @num_tiles = 10
    _load_tiles
    @difficulty = MAX_DIFFICULTY
  end

  def new_game(won = false)
    @field = nil
    @game_over = false
    @visible_field = blank_field
    if won
      increase_difficulty
    else
      decrease_difficulty
    end
  end

  def increase_difficulty
    @difficulty = [difficulty += 1, MAX_DIFFICULTY].min
  end

  def decrease_difficulty
    @difficulty = [difficulty-1, 1].max
  end

  def is_mine?(coords)
    x = coords[:x]
    y = coords[:y]
    return false if x < 0 || y < 0 || x >= @num_tiles || y >= @num_tiles
    return field[y][x] == tile_index(:mine)
  end

  def playable_coordinates?(coords)
    puts "visible #{visible_field}"
    value = visible_field[coords[:y]][coords[:x]]
    value == tile_index(:raised) || value == tile_index(:flag)
  end

  def number_of_adjacent_mines(x, y)
    c = {x: x, y: y}
    adjacent_coords(c).select {|adj| is_mine?(adj)}.count
  end

  def adjacent_to_mine?(x, y)
    number_of_adjacent_mines(x, y) > 0
  end

  def reveal_if_blank(x, y)
    if field[y][x] == tile_index(:blank)
      reveal_at({x: x, y: y}, true)
    end
  end

  def reveal_touching_tiles(x, y)
    reveal_if_blank(x-1, y) if x - 1 >= 0
    reveal_if_blank(x+1, y) if x + 1 < @num_tiles
    reveal_if_blank(x, y - 1) if y - 1 >= 0
    reveal_if_blank(x, y + 1) if y + 1 < @num_tiles
  end

  def reveal_at(coordinates, auto = false)
    unless field
      @field = generate_field(coordinates)
    end

    y = coordinates[:y]
    x = coordinates[:x]
    return if visible_field[y][x] == tile_index(:blank)
    chosen_tile = field[y][x]

    case tile_for_index(chosen_tile)
    when :blank then
      adjacent_mines = number_of_adjacent_mines(x, y)
      if adjacent_mines == 0
        visible_field[y][x] = tile_index(:blank)
      else
        visible_field[y][x] = adjacent_mines
      end

      reveal_touching_tiles(x, y) if (adjacent_mines == 0 || auto == false)

    when :mine then
      @game_over = true
      field.each_with_index do |row, r|
        row.each_with_index do |ft, c|
          if ft == tile_index(:mine)
            visible_field[r][c] = ft
          end
        end
      end
      visible_field[y][x] = tile_index(:red_mine)
    end

    # puts "Chosen tile #{chosen_tile}"
  end

  # for debugging
  def print_field
    field.each do |row|
      row.each do |tile|
        print case tile_for_index(tile)
        when :blank then "•"
        when :mine then "X"
        else "."
        end
      end
      puts
    end
  end

  def flag_count
    visible_field.flatten.select {|t| t == tile_index(:flag) }.count
  end

  def flag_at(coordinates)
    x = coordinates[:x]
    y = coordinates[:y]
    tile = tile_for_index(visible_field[y][x])
    case tile
    when :raised then
      visible_field[y][x] = tile_index(:flag) 
    when :flag then
      visible_field[y][x] = tile_index(:raised)
    end
  end

  def valid_coordinates?(coordinates)
    return false if coordinates[:x] < 0 || coordinates[:x] > @num_tiles -1 || coordinates[:y] < 0 || coordinates[:y] > @num_tiles - 1
    true
  end

  def tile_index(name)
    TILE_POSITIONS.find_index name
  end

  def tile_for_index(index)
    TILE_POSITIONS[index]
  end

  def draw
    draw_border
    draw_tiles
  end

  def border_width
    2 * SCALE_FACTOR
  end

  def draw_border
    line_width = border_width
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
        tile_index = visible_field[y][x]
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
    {
      x: (relative_x / TILE_SIZE).floor,
      y: (relative_y / TILE_SIZE).floor
    }
  end

  def blank_field
    @num_tiles.times.map {
      @num_tiles.times.map { tile_index(:raised) }
    }
  end

  def adjacent_coords(coords)
    x = coords[:x]
    y = coords[:y]
    [
      [x-1, y],    # left
      [x-1, y-1],  # up-left
      [x,   y-1],  # up
      [x+1, y-1],  # up-right
      [x+1, y],    # right
      [x+1, y+1],  # down-right
      [x,   y+1],  # down
      [x-1, y+1]   # down-left
    ].map {|pair| {x: pair[0], y: pair[1]} }
  end

  def mine_count
    mine_chance = [MINIMUM_DIFICULTY_SCALE, difficulty * DIFFICULTY_SCALE].max
    num_mines = (@num_tiles * @num_tiles * mine_chance).floor
  end

  def generate_field(except_coords)
    num_mines = mine_count
    mine_coords = []
    while mine_coords.count < num_mines
      x = Gosu::random(0, @num_tiles).floor
      y = Gosu::random(0, @num_tiles).floor
      coords = {x: x, y: y}
      next if mine_coords.include?(coords)
      next if except_coords == coords
      next if adjacent_coords(except_coords).include?(coords)
      mine_coords << coords
    end

    f = @num_tiles.times.map { |y|
      @num_tiles.times.map { |x|
        tile = mine_coords.include?({x: x, y: y}) ? :mine : :blank
        tile_index(tile)
      }
    }

    unless f.count == @num_tiles && f.all? {|r| r.count == @num_tiles }
      raise "Invalid board!"
    end

    f
  end


end
