require "curses"
require_relative "../backend/model"
require_relative "../utils/logging"

module Frontend

  class SnakeCurses
    include Utils::Logging

    attr_accessor :win, :action_handler, :world

    def prepare!(world)
      raise "action_handler is not set" if action_handler.nil?
      self.world = world
      Curses.init_screen      
      self.win = Curses::Window.new(world.grid.rows + 2, world.grid.cols + 2, 0, 0)
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
      render_frame!(world)
      render_snake!(world)
      render_food!(world)
      win.setpos(0, 0)
      win.refresh
    end

    # Implement ActionProducer interface
    def set_action_handler(game)
      self.action_handler = game
    end

    private

    def render_frame!(world)
      win.setpos(0, 0)
      win.addstr("*" * (world.grid.cols + 2))
      world.grid.rows.times do |x|
        win.setpos(x + 1, 0)
        win.addch("*")
        win.setpos(x + 1, world.grid.cols + 1)
        win.addch("*")
      end

      win.setpos(world.grid.rows + 1, 0)
      win.addstr("*" * (world.grid.cols + 2))
    end

    def render_snake!(world)
      head = world.snake.coordinates.first
      win.setpos(head.row + 1, head.col + 1)
      win.addch("0")
      
      world.snake.coordinates[1..-1].each do |coord|
        win.setpos(coord.row + 1, coord.col + 1)
        win.addch("O")
      end
    end

    def render_food!(world)
      win.setpos(world.food.row + 1, world.food.col + 1)
      win.addch("X")
    end

    def handle_key_down_event(event)
      case event
      when "w"
        action_handler.send_action(:change_snake_direction!, Model::Direction::NORTH)
      when "d"
        action_handler.send_action(:change_snake_direction!, Model::Direction::EAST)
      when "s"
        action_handler.send_action(:change_snake_direction!, Model::Direction::SOUTH)
      when "a"
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
