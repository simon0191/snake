require "ruby2d"
require "byebug"

set title: "Ruby Hunter"

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

class Snake < Struct.new(:grid_config, :coords, keyword_init: true)
  
  def render!
    coords.each_with_index do |coord, i|
      Square.new(
        x: coord.x * grid_config.square_size,
        y: coord.y * grid_config.square_size,
        size: grid_config.square_size,
        color: i == 0 ? 'blue' : 'green'
      )
    end
  end
end

puts get :width
puts get :height
grid_config = Grid::Config.new(
  rows: 400/50,
  cols: 600/50,
  square_size: 50
)

grid = Grid.new(config: grid_config)
snake = Snake.new(grid_config: grid_config, coords: [Coord.new(2,2), Coord.new(2,3), Coord.new(3,3), Coord.new(3,2), Coord.new(3,1)])

grid.render!
snake.render!
show
