require "time"

module ScheduleAnalyzer
  def select_most_consistent_guard(lines)
    parse_schedule(lines)
      .map do |guard_id, times|
        times
          .each_with_object(Hash.new(0)) { |time, hash| hash[time] += 1 }
          .max_by { |_, v| v }
          .yield_self { |time, count| [guard_id, time, count] }
      end
      .max_by { |_, _, count| count.to_i }
      .yield_self { |guard_id, time, _| guard_id * time }
  end

  def select_sleepiest_guard(lines)
    parse_schedule(lines)
      .max_by { |_, times| times.length }
      .yield_self do |guard_id, times|
        times
          .each_with_object(Hash.new(0)) { |time, hash| hash[time] += 1 }
          .max_by { |_, v| v }
          .yield_self { |time, _| guard_id * time }
      end
  end

  def parse_schedule(lines)
    ordered_entries = lines
      .map { |line| parse_line(line) }
      .sort_by { |_, timestamp, _| timestamp }
      .slice_when { |_, (type, _, _)| type == :guard }
      .each_with_object(Hash.new { |h, k| h[k] = [] }) do |((_, _, guard_id), *entries), acc|
        entries
          .each_slice(2)
          .flat_map { |(_, t1, *_), (_, t2, *_)| [*t1.min...t2.min] }
          .yield_self { |times| acc[guard_id] += times }
      end
  end

  def parse_line(line)
    timestamp = Time.parse(line.slice(1..16))
    case line.slice(19..-1)
    when /Guard #(\d+) begins shift/
      [:guard, timestamp, $1.to_i]
    when /falls asleep/
      [:asleep, timestamp]
    when /wakes up/
      [:awake, timestamp]
    end
  end

  def parse_start_message(message)
    message.split(" ")[1].slice(1..-1)
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__

input = File.read(File.expand_path("../input.txt", __FILE__)).strip.split("\n")

puts ScheduleAnalyzer.select_sleepiest_guard(input)
puts ScheduleAnalyzer.select_most_consistent_guard(input)
