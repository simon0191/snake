require "ruby2d"
require_relative "model"
require_relative "view"
require_relative "actions"

class App
  def start!
    extend Ruby2D::DSL
    world = init_world
    renderer = View::Ruby2DRenderer.new(50)
    set title: "Snake"

    on :key_down do |event|
      handle_key_down_event!(world, event)
    end

    last_update = Time.now

    update do
      if Time.now - last_update > 0.5
        last_update = Time.now
        Actions::move_snake!(world)
        renderer.render!(world)
      end
    end

    show
  end

  private
  def init_world
    Model::World.new(
      Model::Grid.new(8, 12,),
      Model::Snake.new(
        [Model::Coordinate.new(2,2), Model::Coordinate.new(2,1)],
        Model::Direction::EAST
      ),
      Model::Coordinate.new(0,0),
      Model::Game.new(false)
    )
  end

  def handle_key_down_event!(world, event)
    next_direction = case event.key
      when "up"
        Model::Direction::NORTH
      when "right"
        Model::Direction::EAST
      when "down"
        Model::Direction::SOUTH
      when "left"
        Model::Direction::WEST
      else
        world.snake.direction
      end
    Actions::change_snake_direction!(world, next_direction)
  end
  
end

App.new.start!