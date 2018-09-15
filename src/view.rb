require "ruby2d"

module View
  class Ruby2DRenderer < Struct.new(:pixel_size)

    def render!(world)
      if world.game.finished
        puts "Finished"
      else
        render_snake!(world)
        render_food!(world)
      end
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
  end
end
