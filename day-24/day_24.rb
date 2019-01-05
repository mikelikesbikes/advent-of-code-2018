require 'pry'

class ImmuneSystem
  attr_reader :immune_system, :infection

  def initialize(immune_system, infection)
    @immune_system = immune_system
    @infection = infection
  end

  def self.from_string(string)
    immune_system, infection = string
      .split("\n\n")
      .map { |str| Army.from_string(str) }
    new(immune_system, infection)
  end

  def boost(x)
    @immune_system.boost(x)
  end

  def winning_army_size
    return nil unless finish_combat
    winner.size
  end

  def winner
    if infection.defeated?
      immune_system
    elsif immune_system.defeated?
      infection
    else
      nil
    end
  end

  def finish_combat
    until winner
      before_sizes = [immune_system.size, infection.size]
      step
      after_sizes = [immune_system.size, infection.size]
      return false if before_sizes == after_sizes
    end
    true
  end

  def step
    targetings = {}
    targetings.merge!(target(immune_system.groups, infection.groups))
    targetings.merge!(target(infection.groups, immune_system.groups))

    targetings
      .sort_by { |g, _| -1 * g.initiative }
      .each do |attacker, target|
        target.take_attack(attacker) if attacker.alive?
      end
  end

  def target(attackers, defenders)
    defenders = defenders.select(&:alive?)
    attackers
      .select(&:alive?)
      .sort_by(&:target_priority)
      .each_with_object({}) do |attacker, targetings|
        target = attacker.best_target(defenders)
        if target
          targetings[attacker] = target
          defenders.delete(target)
        end
      end
  end

  class Army
    attr_reader :groups

    def initialize(groups)
      @groups = groups
    end

    def defeated?
      groups.none?(&:alive?)
    end

    def size
      groups.sum(&:units)
    end

    def boost(x)
      groups.each { |g| g.boost(x) }
    end

    def self.from_string(string)
      name, *groups = string.split("\n")
      name = name.slice(0..-2)
      groups = groups
        .map.with_index do |str, index|
          Group.from_string("#{name} #{index + 1}", str)
        end
      new(groups)
    end

    class Group
      attr_reader :name, :units, :hit_points, :attack_damage, :attack_type, :initiative, :weaknesses, :immunities

      def initialize(name, units:, hit_points:, attack_damage:, attack_type:, initiative:, weaknesses: [], immunities: [])
        @name = name
        @units = units.to_i
        @hit_points = hit_points.to_i
        @attack_damage = attack_damage.to_i
        @attack_type = attack_type
        @initiative = initiative.to_i
        @weaknesses = weaknesses
        @immunities = immunities
      end

      def alive?
        units > 0
      end

      def boost(x)
        @attack_damage += x
      end

      def effective_power
        @attack_damage * @units
      end

      def best_target(targets)
        targets
          .reject { |d| self.effective_power_for(d) == 0 }
          .max_by do |defender|
            [
              self.effective_power_for(defender),
              defender.effective_power,
              defender.initiative
            ]
          end
      end

      def effective_power_for(defender)
        case attack_type
        when *defender.weaknesses then 2 * effective_power
        when *defender.immunities then 0
        else effective_power
        end
      end

      def take_attack(attacker)
        power = attacker.effective_power_for(self)
        @units = [@units - (power / hit_points), 0].max
      end

      def target_priority
        [ -1 * effective_power, -1 * initiative ]
      end

      REGEX = /^(?<units>\d+) units each with (?<hit_points>\d+) hit points (\((?<immunities_and_weaknesses>.*)\) )?with an attack that does (?<attack_damage>\d+) (?<attack_type>\w+) damage at initiative (?<initiative>\d+)$/
      def self.from_string(name, string)
        params = string.match(REGEX).named_captures
        params.merge!(weaknesses_and_immunities(params.delete("immunities_and_weaknesses")))
        new(name, Hash[params.map { |k, v| [k.to_sym, v] }])
      end

      WI_REGEX = /^(?<weak_or_immune>.*) to (?<list>.*)$/
      def self.weaknesses_and_immunities(str)
        hash = {
          weaknesses: [],
          immunities: []
        }
        str
          .to_s
          .split("; ")
          .each do |s|
            params = s.match(WI_REGEX).named_captures
            case params["weak_or_immune"]
            when "weak"
              hash[:weaknesses].push(*params["list"].split(", "))
            when "immune"
              hash[:immunities].push(*params["list"].split(", "))
            end
        end
        hash
      end
    end
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

immune_system = ImmuneSystem.from_string(input)
puts immune_system.winning_army_size

boost = 0
begin
  boost += 1
  immune_system = ImmuneSystem.from_string(input)
  immune_system.boost(boost)
end until immune_system.finish_combat && immune_system.infection.defeated?
puts immune_system.winning_army_size

