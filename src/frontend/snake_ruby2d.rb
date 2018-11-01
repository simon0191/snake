require "ruby2d"
require_relative "../backend/model"

module Frontend
  class SnakeRuby2d
    attr_accessor :pixel_size, :action_handler, :world

    def initialize(pixel_size)
      self.pixel_size = pixel_size
    end

    def start!
      raise "action_handler is not set" if action_handler.nil?

      extend Ruby2D::DSL
      set(title: "Snake", width: 600, height: 400, viewport_width: 600, viewport_height: 400)
      extend Ruby2D::DSL
      on :key_down do |event|
        handle_key_down_event(event)
      end
      curr_hash = nil
      update do
        if world.hash != curr_hash
          if world.game.finished
            puts "Finished"
          else
            render_snake!(world)
            render_food!(world)
          end
          curr_hash = world.hash
        end
      end

      show
    end
    
    # Implement Renderer interface
    def render!(world)
      self.world = world
    end

    # Implement ActionProducer interface
    def set_action_handler(game)
      self.action_handler = game
    end

    private

    def render_snake!(world)
      extend Ruby2D::DSL
      @squares.each(&:remove) unless @squares.nil?
      @squares = world.snake.coordinates.map do |coord|
        Square.new(
          size: pixel_size,
          x: coord.col * pixel_size,
          y: coord.row * pixel_size,
          color: 'green')
      end
    end

    def render_food!(world)
      extend Ruby2D::DSL
      @food.remove unless @food.nil?
      @food = Square.new(
        size: pixel_size,
        x: world.food.col * pixel_size,
        y: world.food.row * pixel_size,
        color: 'yellow')
    end

    def handle_key_down_event(event)
      case event.key
      when "up", "W", "w"
        action_handler.send_action(:change_snake_direction!, Model::Direction::NORTH)
      when "right", "D", "d"
        action_handler.send_action(:change_snake_direction!, Model::Direction::EAST)
      when "down", "S", "s"
        action_handler.send_action(:change_snake_direction!, Model::Direction::SOUTH)
      when "left", "A", "a"
        action_handler.send_action(:change_snake_direction!, Model::Direction::WEST)
      when "r"
        action_handler.send_action(:restart!)
      when "1"
        action_handler.send_action(:decrease_speed!)
      when "2"
        action_handler.send_action(:increase_speed!)
      when "space"
        action_handler.send_action(:toggle_pause!)
      end
    end
  end
end
