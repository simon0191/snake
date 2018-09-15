require "ruby2d"
require "byebug"

class Grid < Struct.new(:config, keyword_init: true)
  class Config < Struct.new(:cols, :rows, :square_size, keyword_init: true)
    def self.default
      self.new(
        rows: 400/50,
        cols: 600/50,
        square_size: 50)
    end
  end

  def config
    @_config ||= Config.new(Config::default.to_h.merge(super.to_h))
  end

  def render!
    extend Ruby2D::DSL
    # Draw cols delimiters
    (0..config.cols).each do |i|
      Line.new(
        x1: i * config.square_size,
        y1: 0,
        x2: i * config.square_size,
        y2: config.rows * config.square_size,
        z: 1
      )
    end
    # Draw rows delimiters
    (0..config.rows).each do |i|
      Line.new(
        x1: 0,
        y1: i * config.square_size,
        x2: config.cols * config.square_size,
        y2: i * config.square_size,
        z: 1
      )
    end
  end
end

class Coord < Struct.new(:x, :y)
end

class Direction < Struct.new(:coord)
  NORTH = Direction.new(Coord.new(0, -1)).freeze
  EAST = Direction.new(Coord.new(1, 0)).freeze
  SOUTH = Direction.new(Coord.new(0, 1)).freeze
  WEST = Direction.new(Coord.new(-1, 0)).freeze
end

class Snake < Struct.new(:grid_config, :coords, :direction, keyword_init: true)

  def render!
    @squares = coords.each_with_index.map do |coord, i|
      Square.new(
        x: coord.x * grid_config.square_size,
        y: coord.y * grid_config.square_size,
        size: grid_config.square_size,
        color: i == 0 ? 'blue' : 'green'
      )
    end
  end

  def advance
    (1...@squares.size).reverse_each do |idx|
      @squares[idx].x = @squares[idx - 1].x
      @squares[idx].y = @squares[idx - 1].y
    end
    @squares.first.x += (direction.coord.x * grid_config.square_size)
    @squares.first.y += (direction.coord.y * grid_config.square_size)
  end
end

class SnakeGame
  
  def start!
    extend Ruby2D::DSL
    set title: "Snake"

    grid_config = Grid::Config.new(rows: 400/50, cols: 600/50, square_size: 50)
    grid = Grid.new(config: grid_config)
    snake = Snake.new(
      grid_config: grid_config,
      coords: [Coord.new(2,2), Coord.new(2,3), Coord.new(3,3), Coord.new(3,2), Coord.new(3,1)],
      direction: Direction::NORTH)

    grid.render!
    snake.render!
    next_direction = snake.direction

    on :key_down do |e|
      puts "#{e.key} was pressed down!"
      case e.key
      when "up"
        next_direction = Direction::NORTH if snake.direction != Direction::SOUTH
      when "right"
        next_direction = Direction::EAST if snake.direction != Direction::WEST
      when "down"
        next_direction = Direction::SOUTH if snake.direction != Direction::NORTH
      when "left"
        next_direction = Direction::WEST if snake.direction != Direction::EAST
      end
    end

    last_update = Time.now

    food = Coord.new(rand(), rand())

    update do
      if Time.now - last_update > 0.5
        last_update = Time.now
        snake.direction = next_direction
        snake.advance
      end
    end

    show
  end
end

SnakeGame.new.start!