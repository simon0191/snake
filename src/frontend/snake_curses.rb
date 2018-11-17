require "curses"
require_relative "../backend/model"

module Frontend
  class SnakeCurses
    attr_accessor :win, :action_handler, :world

    def prepare!(world)
      raise "action_handler is not set" if action_handler.nil?
      self.world = world
      Curses.init_screen      
      self.win = Curses::Window.new(world.grid.rows, world.grid.cols, 0, 0)
      #self.win.nodelay = true
      self.win.box("\\", "/")
      self.win.refresh
    end

    def start!
      loop do
        break if world.game.exit
        handle_key_down_event(self.win.getch)
      end
      self.win.close
    end
    
    # Implement Renderer interface
    def render!(world)
      win.clear
      self.world = world
      render_snake!(world)
      render_food!(world)
      win.refresh
    end

    # Implement ActionProducer interface
    def set_action_handler(game)
      self.action_handler = game
    end

    private

    def render_snake!(world)
      world.snake.coordinates.each do |coord|
        win.setpos(coord.row, coord.col)
        win.addch("O")
      end
    end

    def render_food!(world)
      win.setpos(world.food.row, world.food.col)
      win.addch("X")
    end

    def handle_key_down_event(event)
      case event
      when Curses::KEY_UP, "W", "w"
        action_handler.send_action(:change_snake_direction!, Model::Direction::NORTH)
      when Curses::KEY_RIGHT, "D", "d"
        action_handler.send_action(:change_snake_direction!, Model::Direction::EAST)
      when Curses::KEY_DOWN, "S", "s"
        action_handler.send_action(:change_snake_direction!, Model::Direction::SOUTH)
      when Curses::KEY_LEFT, "A", "a"
        action_handler.send_action(:change_snake_direction!, Model::Direction::WEST)
      when "r"
        action_handler.send_action(:restart!)
      when "1"
        action_handler.send_action(:decrease_speed!)
      when "2"
        action_handler.send_action(:increase_speed!)
      when " "
        action_handler.send_action(:toggle_pause!)
      when "q", "Q"
        action_handler.send_action(:exit_game!)
      end
      render!(world)
    end
  end
end
