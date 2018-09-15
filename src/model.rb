module Model
  module Direction
    NORTH = 'north'.freeze
    EAST  = 'east'.freeze
    SOUTH = 'south'.freeze
    WEST = 'west'.freeze
  end

  class Coordinate < Struct.new(:row, :col)
  end

  class Snake < Struct.new(:coordinates, :direction)
  end

  class Grid < Struct.new(:rows, :cols)
  end

  class Game < Struct.new(:finished, :squares_per_second, :next_direction)
  end

  class World < Struct.new(:grid, :snake, :food, :game)
  end

  def self.init_world
    Model::World.new(
      Model::Grid.new(8, 12,),
      Model::Snake.new(
        [Model::Coordinate.new(2,2), Model::Coordinate.new(2,1)],
        Model::Direction::EAST
      ),
      Model::Coordinate.new(0,0),
      Model::Game.new(false, 1.0, Model::Direction::EAST)
    )
  end
end

=begin
{
  world: {
    game: {
      finished: true
    },
    grid: {
      cols: 10,
      rows: 10
    },
    snake : {
      coordinates: [
        {row: 1, col: 1}, // Coordinate
        {row: 2, col: 1}
      ],
      direction: 'NORTH'
    },
    food: {
      row: 7, // Coordinate
      col: 9
    }
  }
}
=end