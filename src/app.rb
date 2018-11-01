require_relative "frontend/snake_ruby2d"
require_relative "backend/game"
require_relative "backend/model"

class App
  def start!
    world = Model::init_world
    renderer = Frontend::SnakeRuby2d.new(50)
    game = SnakeGame.new(world, renderer)
    renderer.set_action_handler(game)
    
    game_thread = Thread.new { game.start! }
    renderer.start!
  end
end

App.new.start!
