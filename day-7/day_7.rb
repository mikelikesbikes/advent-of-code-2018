require "time"

module SleighIntstructionCollator
  class InstructionTree
    attr_reader :nodes

    def initialize
      @nodes = []
    end

    def worked_order(concurrency, &block)
      finished = []
      in_progress = Array.new(concurrency)
      ready, waiting = nodes.partition { |node| node.satisfied?(finished) }
      time = 0
      until in_progress.none? && ready.length == 0 && waiting.length == 0
        # process in_progress work
        in_progress.each_with_index do |(finish_time, node), i|
          newly_finished = []
          if node && time >= finish_time
            newly_finished << node
            in_progress[i] = nil
          end
          finished.push(*newly_finished.sort_by(&:data))
        end

        # adjust remaining work
        newly_ready, waiting = waiting.partition { |node| node.satisfied?(finished) }
        ready.push(*newly_ready).sort_by! { |n| n.data }

        # start new work
        in_progress.each_with_index do |w, i|
          if ready.length > 0 && !w
            node = ready.shift
            work_time = block ? block.call(node.data) : 1
            in_progress[i] = [time + work_time, node]
          end
        end

        print_state(finished, in_progress, time)
        time += 1
      end
      [finished, time - 1]
    end

    def print_state(finished, in_progress, time)
      puts "#{time.to_s.rjust(5)} #{in_progress.map { |_, n| (n&.data || ".").rjust(5) }.join("   ")} #{finished.map(&:data).join}"
    end

    def find_node(data)
      nodes.find { |node| node.data == data } ||
        Node.new(data).tap { |node| self.nodes << node }
    end

    def empty?
      root.empty?
    end

    class Node
      attr_reader :data, :upstream_nodes

      def initialize(data, upstream_nodes = [])
        @data = data
        @upstream_nodes = upstream_nodes
      end

      def depends_on(node)
        upstream_nodes.push(node)
      end

      def inspect
        "#<#{self.class.name} data=#{data.inspect} upstream_nodes=#{upstream_nodes.inspect}>"
      end

      def empty?
        upstream_nodes.empty?
      end

      def satisfied?(nodes)
        (upstream_nodes - nodes).empty?
      end
    end
  end

  def worked_order(input, concurrency=1, &block)
    input
      .map { |line| parse_vertex(line) }
      .each_with_object(InstructionTree.new) do |(left, right), tree|
        left_node = tree.find_node(left)
        right_node = tree.find_node(right)
        right_node.depends_on(left_node)
      end
      .worked_order(concurrency, &block)
      .yield_self do |finished_nodes, time|
        [finished_nodes.map(&:data).join, time]
      end
  end

  def parse_vertex(line)
    [line[5], line[36]]
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip.split("\n")

puts SleighIntstructionCollator.worked_order(input)
puts SleighIntstructionCollator.worked_order(input, 5) { |w| w.ord - 'A'.ord + 61 }
