require_relative "model"

module Actions
  def self.change_snake_direction!(world, direction)
    world.game.next_direction = case direction
    when Model::Direction::NORTH
      world.snake.direction != Model::Direction::SOUTH ? direction : world.snake.direction
    when Model::Direction::EAST
      world.snake.direction != Model::Direction::WEST ? direction : world.snake.direction
    when Model::Direction::SOUTH
      world.snake.direction != Model::Direction::NORTH ? direction : world.snake.direction
    when Model::Direction::WEST
      world.snake.direction != Model::Direction::EAST ? direction : world.snake.direction
    else
      world.snake.direction
    end
    puts world.inspect
    world
  end

  def self.move_snake!(world)
    next_coord = calc_next_coord(world)

    if is_outside_world?(world, next_coord) || is_over_snake?(world, next_coord)
      end_game!(world)
    elsif has_food?(world, next_coord)
      grow_snake!(world, next_coord)
      generate_new_piece_of_food!(world)
      increase_speed!(world)
    else
      move_snake_to_coord!(world, next_coord)
    end
    puts world.inspect
    world
  end

  def self.restart!
    world = Model::init_world
    puts world.inspect
    world
  end

  def self.increase_speed!(world)
    world.game.squares_per_second += 0.1
    puts world.inspect
    world
  end

  def self.decrease_speed!(world)
    world.game.squares_per_second = [world.game.squares_per_second - 0.1, 1].max
    puts world.inspect
    world
  end

  def self.toggle_pause!(world)
    world.game.paused = !world.game.paused
    puts world.inspect
    world
  end

  private

  def self.calc_next_coord(world)
    case world.game.next_direction
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
    world.snake.direction = world.game.next_direction
    world.snake.coordinates.prepend(next_coord)
    world.snake.coordinates.pop
  end
end
