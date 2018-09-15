require 'ruby2d'

set title: "Hello Triangle"

Triangle.new(
  x1: 320, y1:  50,
  x2: 540, y2: 430,
  x3: 100, y3: 430,
  color: ['red', 'green', 'blue']
)
#t = Time.now
#update do
#  # Close the window after 5 seconds
#  if Time.now - t > 5 then close end
#end

require 'ruby2d'

interactive_squares = []

class Grid
  
end

class InteractiveSquare
  def initialize(x, y)
    extend Ruby2D::DSL

    @square = Square.new(x: x, y: y, color: "green")

    @hover_event = on :mouse_move do |e|
      if @square.contains?(e.x, e.y)
        @square.color = "red"
      else
        @square.color = "green"
      end
    end

    @remove_event = on :mouse_up do |e|
      if e.button == :right
        if @square.contains?(e.x, e.y)
          self.remove
        end
      end
    end
  end

  def remove
    @square.remove
    off(@hover_event)
    off(@remove_event)
  end
end

on :mouse_down do |e|
  if e.button == :left
    interactive_squares << InteractiveSquare.new(e.x, e.y)
  end
end

show
