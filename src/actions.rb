require_relative "model"
=begin
{
  game: {
    finished: true
  },
  world: {
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

actions:

- arrow key press -> 
  - change direction of snake
- snake move ->
  - if the next coord is outside of the grid ->
    - end game
  - if the next coord is overlaping the snake ->
    - end game
  - if there's food in the next coord ->
    - grow the snake ("eat the piece of food")
    - generate a new piece of food
  - else
    - move the snake to the next coord
=end

module Actions
  def self.change_snake_direction!(world, direction)
    world.snake.direction = direction
    world
  end

  def self.move_snake!(world)
    next_coord = calc_next_coord(world)

    if is_outside_world?(world, next_coord) || is_over_snake?(world, next_coord)
      end_game!(world)
    elsif has_food?(world, next_coord)
      grow_snake!(world, next_coord)
      generate_new_piece_of_food!(world)
    else
      move_snake_to_coord!(world, next_coord)
    end

    world
  end

  private

  def self.calc_next_coord(world)
    case world.snake.direction
    when Model::Direction::NORTH
      Model::Coordinate.new(world.snake.coordinates.first.row - 1, world.snake.coordinates.first.col)
    when Model::Direction::EAST
      Model::Coordinate.new(world.snake.coordinates.first.row, world.snake.coordinates.first.col + 1)
    when Model::Direction::SOUTH
      Model::Coordinate.new(world.snake.coordinates.first.row + 1, world.snake.coordinates.first.col)
    when Model::Direction::WEST
      Model::Coordinate.new(world.snake.coordinates.first.row, world.snake.coordinates.first.col - 1)
    end
  end

  def self.is_outside_world?(world, next_coord)
    (next_coord.col < 0 || 
      next_coord.row < 0 || 
      next_coord.col >= world.grid.cols || 
      next_coord.row >= world.grid.rows)
  end

  def self.is_over_snake?(world, next_coord)
    world.snake.coordinates.include? next_coord
  end

  def self.end_game!(world)
    world.game.finished = true
  end

  def self.has_food?(world, next_coord)
    world.food == next_coord
  end

  def self.grow_snake!(world, next_coord)
    world.snake.coordinates.prepend next_coord
  end

  def self.generate_new_piece_of_food!(world)
    loop do
      new_food = Model::Coordinate.new(rand(world.grid.rows), rand(world.grid.cols))
      if !is_over_snake?(world, new_food)
        world.food = new_food
        break
      end
    end
  end

  def self.move_snake_to_coord!(world, next_coord)
    world.snake.coordinates.prepend(next_coord)
    world.snake.coordinates.pop
  end
end
