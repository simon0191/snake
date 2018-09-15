require "ruby2d"
require_relative "model"
require_relative "view"
require_relative "actions"

class App
  def start!
    extend Ruby2D::DSL
    world = Model::init_world
    renderer = View::Ruby2DRenderer.new(50)
    on :key_down do |event|
      world = handle_key_down_event(world, event)
    end

    last_update = Time.now

    update do
      if Time.now - last_update > (1.0/world.game.squares_per_second)
        last_update = Time.now
        Actions::move_snake!(world)
        renderer.render!(world)
      end
    end

    show
  end

  private

  def handle_key_down_event(world, event)
    case event.key
    when "up", "W", "w"
      Actions::change_snake_direction!(world, Model::Direction::NORTH)
    when "right", "D", "d"
      Actions::change_snake_direction!(world, Model::Direction::EAST)
    when "down", "S", "s"
      Actions::change_snake_direction!(world, Model::Direction::SOUTH)
    when "left", "A", "a"
      Actions::change_snake_direction!(world, Model::Direction::WEST)
    when "r"
      Actions::restart!
    when "1"
      Actions::decrease_speed!(world)
    when "2"
      Actions::increase_speed!(world)
    else
      world
    end
  end
  
end
set(title: "Snake", width: 600, height: 400, viewport_width: 600, viewport_height: 400)
App.new.start!