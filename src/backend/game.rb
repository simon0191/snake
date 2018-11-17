require_relative "actions"

class SnakeGame 
  attr_accessor :world, :renderer, :world_lock

  def initialize(world, renderer)
    self.world_lock = Mutex.new
    self.world = world
    self.renderer = renderer
  end

  # Starts the game loop
  def start!
    last_update = Time.now

    loop do
      break if world.game.exit
      prev_hash = world.hash
      send_action(:tick!, Time.now - last_update)
      renderer.render!(world) if prev_hash != world.hash
      last_update = Time.now
      sleep 0.03
    end
  end

  # Receives and action and it's params and redirects them to the Actions module
  def send_action(action, *params)
    world_lock.synchronize { self.world = Actions.send(action, world, *params) }
  end
end


## Interfaces
#class Renderer
#  self.abstract_class = true
#  def render(world)
#    raise 'Abstract method'
#  end
#end
#
#class ActionProducer
#  self.abstract_class = true
#  def set_action_handler(game)
#    raise 'Abstract method'
#  end
#end
