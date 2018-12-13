class Railway
  attr_reader :track, :cars, :crashes
  def initialize(track, cars)
    @track = track
    @cars = cars
    @crashes = []
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
        if other_car = cars.find { |c| c != car && c.location == car.location }
          crashes << car.location
          cars.delete(car)
          cars.delete(other_car)
        end
      end
  end

  class Car
    attr_reader :direction

    def initialize(current_location, direction)
      @x, @y = current_location
      @direction = direction
      @intersection_offset = 0
    end

    def inspect
      "#<Car location:[#{@x}, #{@y}] dir: \"#{direction}\">"
    end

    def tick(track)
      change_direction_if_needed(track)
      case direction
      when "v"
        @y += 1
      when "^"
        @y -= 1
      when ">"
        @x += 1
      when "<"
        @x -= 1
      end
    end

    def location
      [@x, @y]
    end

    private

    def change_direction_if_needed(track)
      if track[location] == "/"
        case direction
        when "^" then turn_right
        when ">" then turn_left
        when "v" then turn_right
        when "<" then turn_left
        end
      elsif track[location] == "\\"
        case direction
        when "^" then turn_left
        when ">" then turn_right
        when "v" then turn_left
        when "<" then turn_right
        end
      elsif track[location] == "+"
        case @intersection_offset % 3
        when 0 then turn_left
        when 2 then turn_right
        end
        @intersection_offset += 1
      end
    end

    def turn_left
      @direction = case direction
      when "^" then "<"
      when "<" then "v"
      when "v" then ">"
      when ">" then "^"
      end
    end

    def turn_right
      @direction = case direction
      when "^" then ">"
      when ">" then "v"
      when "v" then "<"
      when "<" then "^"
      end
    end
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename)

railway = Railway.from_string(input)
puts railway.first_crash_location.join(",")
puts railway.last_car_location.join(",")
