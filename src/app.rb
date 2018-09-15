require "ruby2d"

set title: "Ruby Hunter"

interactive_squares = []

class Grid
  DEFAULT_OPTS = {
    cols: 600/50,
    rows: 400/50,
    square_size: 50
  }
  def initialize(opts)
    extend Ruby2D::DSL
    opts = DEFAULT_OPTS.merge(opts)
    # Draw rows delimiters
    (0..opts[:cols]).each do |i|
      Line.new(
        x1: 0,
        y1: i * opts[:square_size],
        x2: opts[:rows] * opts[:square_size],
        y2: i * opts[:square_size]
      )
    end
    # Draw cols delimiters
    (0..opts[:rows]).each do |i|
      Line.new(
        x1: i * opts[:square_size],
        y1: 0,
        x2: i * opts[:square_size],
        y2: opts[:cols] * opts[:square_size]
      )
    end
  end
end

puts get :width
puts get :height
Grid.new(
  rows: 600/50,
  cols: 400/50,
  square_size: 50
)
show
