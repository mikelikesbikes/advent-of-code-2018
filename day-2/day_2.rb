module BoxScanner
  def checksum(boxes)
    twos = threes = 0
    boxes.each do |box|
      char_counts = box.chars.each_with_object(Hash.new(0)) { |c, h| h[c] += 1 }
      twos += 1 if char_counts.find { |c, count| count == 2 }
      threes += 1 if char_counts.find { |c, count| count == 3 }
    end
    twos * threes
  end

  def common_letters(boxes)
    box1, box2 = common_boxes(boxes)
    box1.chars.zip(box2.chars).each_with_object("") { |(a, b), l| l << a if a == b }
  end

  def common_boxes(boxes)
    box1, *boxes = boxes
    while boxes.length > 0
      boxes.each do |box2|
        return [box1, box2] if similar?(box1, box2)
      end
      box1, *boxes = boxes
    end
  end

  def similar?(box1, box2)
    diffs = 0
    box1.chars.zip(box2.chars).each do |a, b|
      diffs += 1 unless a == b
      return false if diffs > 1
    end
    true
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__

input = File.read(File.expand_path("input.txt", __dir__)).split("\n")

puts BoxScanner.checksum(input)
puts BoxScanner.common_letters(input)
