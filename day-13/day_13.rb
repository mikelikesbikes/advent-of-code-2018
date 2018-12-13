class Railway
  attr_reader :track, :cars, :crashes, :ticks

  def initialize(track, cars)
    @track = track
    @cars = cars
    @crashes = []
    @ticks = 0
  end

  def first_crash_location
    tick_while { |r| r.crashes.empty? }
    crashes.first
  end

  def tick_while(&block)
    tick while block.call(self)
    self
  end

  def last_car_location
    tick_while { |r| r.cars.length > 1 }
    cars.first.location
  end

  def self.from_string(string)
    rows = string.split("\n")
    cars = []
    track = rows.each_with_object({}).with_index do |(row, track), y|
      row.chars.each.with_index do |char, x|
        case char
        when "<", "^", ">", "v"
          Car.new([x, y], char).tap do |car|
            cars << car
            track[[x,y]] = "."
          end
        when "/", "\\", "+"
          track[[x,y]] = char
        when "|", "-"
          track[[x,y]] = "."
        end
      end
    end

    new(track, cars)
  end

  def tick
    cars
      .sort_by { |c| c.location.reverse }
      .each do |car|
        car.tick(track)
        handle_crash_if_needed(car)
      end
    @ticks += 1
  end

  private

  def handle_crash_if_needed(car)
    if other_car = cars.find { |c| c != car && c.location == car.location }
      crashes << car.location
      cars.delete(car)
      cars.delete(other_car)
    end
  end
end

class Railway
  class Car
    DIRECTIONS = %w[ ^ > v < ]

    def initialize(current_location, direction)
      @x, @y = current_location
      @direction_offset = DIRECTIONS.index(direction)
      @intersection_offset = 0
    end

    def direction
      DIRECTIONS[@direction_offset % 4]
    end

    def inspect
      "#<Car location:[#{@x}, #{@y}] dir: \"#{direction}\">"
    end

    def tick(track)
      change_direction_if_needed(track)
      move_forward
    end

    def location
      [@x, @y]
    end

    private

    def move_forward
      case direction_index
      when 0 then @y -= 1
      when 1 then @x += 1
      when 2 then @y += 1
      when 3 then @x -= 1
      end
    end

    def change_direction_if_needed(track)
      if track[location] == "/"
        case direction_index
        when 0, 2 then turn_right
        when 1, 3 then turn_left
        end
      elsif track[location] == "\\"
        case direction_index
        when 0, 2 then turn_left
        when 1, 3 then turn_right
        end
      elsif track[location] == "+"
        case @intersection_offset % 3
        when 0 then turn_left
        when 2 then turn_right
        end
        @intersection_offset += 1
      end
    end

    def direction_index
      @direction_offset % 4
    end

    def turn_left
      @direction_offset -= 1
    end

    def turn_right
      @direction_offset += 1
    end
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename)

railway = Railway.from_string(input)
puts railway.first_crash_location.join(",")
puts railway.last_car_location.join(",")
