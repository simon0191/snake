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

  class Game < Struct.new(:finished)
  end

  class World < Struct.new(:grid, :snake, :food, :game)
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