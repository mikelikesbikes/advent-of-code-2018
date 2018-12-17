require "set"

class BeverageCombat
  WALL_SPACE = "#".freeze
  OPEN_SPACE = ".".freeze

  attr_reader :units
  def initialize(map, units)
    @map = map
    @units = units
    @initial_elf_count = elf_count
    @rounds = 0
  end

  def outcome
    until battle_over?
      @rounds += 1 if round
    end
    units.sum(&:hit_points) * @rounds
  end

  def elf_count
    units.count { |u| u.type == "E" }
  end

  def flawless_outcome
    result = outcome
    elf_count == @initial_elf_count ? result : nil
  end

  def battle_over?
    units.map(&:type).uniq.length == 1
  end

  def to_s
    map.map.with_index do |row, y|
      row.map.with_index do |pos, x|
        (unit = unit_at([x, y])) ? unit.type : pos
      end.join
    end.join("\n")
  end

  def unit_at(position)
    units.find { |unit| unit.position == position }
  end

  def round
    units
      .sort_by { |unit| unit.position.reverse }
      .each do |unit|
        return false if battle_over?
        take_turn(unit)
      end
    true
  end

  def take_turn(unit)
    return if unit.hit_points <= 0
    move(unit)
    attack(unit)
  end

  def enemies_adjacent_to(unit)
    adjacent_spaces = spaces_adjacent_to(unit.position)
    enemies_of(unit)
      .select { |enemy| adjacent_spaces.include?(enemy.position) }
  end

  def move(unit)
    return false unless enemies_adjacent_to(unit).empty?

    in_range = enemies_of(unit)
      .map { |enemy| open_spaces_adjacent_to(enemy.position) }
      .reduce(Set.new, :union)

    next_position = in_range
      .map do |space|
        d, step = distance(unit.position, space)
        [d, space, step]
      end
      .select { |d, _| d }
      .min_by { |d, space, step| [d, *space.reverse, *step.reverse] }
      &.last

    return false unless next_position

    oldx, oldy = unit.position
    newx, newy = unit.position = next_position
    map[oldy][oldx] = OPEN_SPACE
    map[newy][newx] = unit.type
    true
  end

  def reachable(space, spaces)
    spaces
      .map { |other| [other, distance(space, other)] }
      .select { |_, dist| dist }
      .min_by { |space, (d, (x, y))| [d, y, x] }
      &.first
  end

  def distance(this, other)
    visited = Set.new
    to_visit = Set.new([other])
    distance = 0

    until to_visit.empty?
      to_visit = to_visit
        .sort_by { |(x, y)| [y, x] }
        .each_with_object(Set.new) do |current_space, s|
        unless visited.member?(current_space)
          visited << current_space
          adjacent_spaces = spaces_adjacent_to(current_space)

          return [distance, current_space] if adjacent_spaces.include?(this)

          adjacent_spaces.each do |space|
            s << space if map(space) == OPEN_SPACE
          end
        end
      end
      distance += 1
    end

    nil
  end

  def step_on_shortest_path(this, other)
    visited = Set.new
    to_visit = Set.new([other])
    adjacents = Set.new

    while !to_visit.empty? && adjacents.empty?
      to_visit = to_visit
        .sort_by { |(x, y)| [y, x] }
        .each_with_object(Set.new) do |current_space, s|
          visited << current_space
          adjacent_spaces = spaces_adjacent_to(current_space)

          adjacent_spaces.each do |space|
            adjacents << current_space if space == this
            s << space if map(space) == OPEN_SPACE
          end
        end
    end

    adjacents.sort_by(&:reverse).first
  end

  def map(position = nil)
    if position
      @map[position.last][position.first]
    else
      @map
    end
  end

  def spaces_adjacent_to((x, y))
    [ [ 0, -1],
      [-1,  0],
      [ 1,  0],
      [ 0,  1] ]
      .map { |(dx, dy)| [x + dx, y + dy] }
  end

  def open_spaces_adjacent_to(space)
    spaces_adjacent_to(space)
      .select { |space| map(space) == OPEN_SPACE }
  end

  def enemies_of(unit)
    units.reject { |other| other.type == unit.type }
  end

  def attack(unit)
    target = enemies_adjacent_to(unit)
      .min_by { |enemy| [enemy.hit_points, *enemy.position.reverse] }

    return false unless target

    target.hit_points -= unit.attack_points

    if target.hit_points <= 0
      units.delete(target)
      x,y = target.position
      map[y][x] = OPEN_SPACE
    end
  end

  def self.from_string(input, elf_attack_points = 3)
    map = input.split("\n").map { |line| line.chars }
    units = map.each_with_object([]).with_index do |(row, units), y|
      row.each_with_index do |s, x|
        if s == "E"
          units << Unit.new(s, [x, y], attack_points: elf_attack_points)
        elsif s == "G"
          units << Unit.new(s, [x, y])
        end
      end
    end

    new(map, units)
  end

  def self.flawless_outcome(input)
    min = 1
    max = 200

    while max - min > 1
      mid = (max + min + 1) / 2
      game = from_string(input, mid)
      if game.flawless_outcome
        max = mid
      else
        min = mid
      end
    end

    game.outcome
  end

  class Unit
    attr_reader :type, :attack_points
    attr_accessor :position, :hit_points
    def initialize(type, position, hit_points: 200, attack_points: 3)
      @type = type
      @hit_points = hit_points
      @attack_points = attack_points
      @position = position
    end

    def inspect
      nice_type = type == "E" ? "Elf" : "Goblin"
      "<##{nice_type} position=#{position.join(",")} hit_points=#{hit_points} attack_points=#{attack_points}>"
    end
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

puts BeverageCombat.from_string(input).outcome
puts BeverageCombat.flawless_outcome(input)
