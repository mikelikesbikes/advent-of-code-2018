require "set"

class BeverageCombat
  WALL_SPACE = "#".freeze
  OPEN_SPACE = ".".freeze

  attr_reader :units
  def initialize(map, units)
    @map = map
    @units = units
  end

  def outcome
    rounds = 0
    until battle_over?
      rounds += 1 if round
    end
    units.sum(&:hit_points) * rounds
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

  def move(unit)
    enemy_positions = enemies_of(unit).map { |enemy| enemy.position }
    return false if spaces_adjacent_to(unit.position).any? { |space| enemy_positions.include?(space) }

    in_range = enemies_of(unit)
      .each_with_object(Set.new) do |enemy, s|
        open_spaces_adjacent_to(enemy.position)
          .select { |space| map(space) == OPEN_SPACE }
          .each { |open_cell| s << open_cell }
      end

    chosen_space = reachable(unit.position, in_range)
    return false unless chosen_space

    next_position = step_on_shortest_path(unit.position, chosen_space)

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
    adjacent_spaces = spaces_adjacent_to(unit.position)
    target = enemies_of(unit)
      .select { |enemy| adjacent_spaces.include?(enemy.position) }
      .min_by { |enemy| [enemy.hit_points, *enemy.position.reverse] }

    return false unless target

    target.hit_points -= unit.attack_points

    if target.hit_points <= 0
      units.delete(target)
      x,y = target.position
      map[y][x] = OPEN_SPACE
    end
  end

  def self.from_string(input)
    map = input.split("\n").map { |line| line.chars }
    units = map.each_with_object([]).with_index do |(row, units), y|
      row.each_with_index do |s, x|
        units << Unit.new(s, [x, y]) unless s == OPEN_SPACE || s == WALL_SPACE
      end
    end

    new(map, units)
  end

  class Unit
    attr_reader :type, :attack_points
    attr_accessor :position, :hit_points
    def initialize(type, position, hit_points = 200, attack_points = 3)
      @type = type
      @hit_points = hit_points
      @attack_points = attack_points
      @position = position
    end

    def inspect
      nice_type = type == "E" ? "Elf" : "Goblin"
      "<##{nice_type} position=#{position.join(",")} hit_points=#{hit_points}>"
    end
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

puts BeverageCombat.from_string(input).outcome
