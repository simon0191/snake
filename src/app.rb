require_relative "frontend/snake_ruby2d"
require_relative "frontend/snake_curses"
require_relative "backend/game"
require_relative "backend/model"

class App

  def self.build_frontend(frontend_name)
    case frontend_name
    when "ruby2d"
      Frontend::SnakeRuby2d.new(50)
    else
      Frontend::SnakeCurses.new
    end
  end

  def start!(frontend)
    world = Model::init_world
    renderer = App::build_frontend(frontend)
    game = SnakeGame.new(world, renderer)
    renderer.set_action_handler(game)
    renderer.prepare!(world)
    game_thread = Thread.new { game.start! }
    renderer.start!
  end
end

frontend, * = ARGV
App.new.start!(frontend)
