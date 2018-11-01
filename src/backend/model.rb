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

  class Game < Struct.new(:finished, :squares_per_second, :next_direction, :paused, :curr_time, :last_update)
  end

  class World < Struct.new(:grid, :snake, :food, :game)
  end

  def self.init_world
    Model::World.new(
      Model::Grid.new(8, 12),
      Model::Snake.new(
        [Model::Coordinate.new(2,4), Model::Coordinate.new(2,3), Model::Coordinate.new(2,2), Model::Coordinate.new(2,1), Model::Coordinate.new(2,0)],
        Model::Direction::EAST
      ),
      Model::Coordinate.new(0,0),
      Model::Game.new(false, 3.0, Model::Direction::EAST, false, 0.0, 0.0)
    )
  end
end
