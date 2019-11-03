require_relative "./day_25.rb"

describe FixedPoints do
  examples = []
  examples << [<<~INPUT.strip, 2]
     0,0,0,0
     3,0,0,0
     0,3,0,0
     0,0,3,0
     0,0,0,3
     0,0,0,6
     9,0,0,0
    12,0,0,0
    INPUT
  examples << [<<~INPUT.strip, 4]
    -1,2,2,0
    0,0,2,-2
    0,0,0,-2
    -1,2,0,0
    -2,-2,-2,2
    3,0,2,-1
    -1,3,2,2
    -1,0,-1,0
    0,2,1,-2
    3,0,0,0
    INPUT
  examples << [<<~INPUT.strip, 3]
    1,-1,0,1
    2,0,-1,0
    3,2,-1,0
    0,0,3,1
    0,0,-1,-1
    2,3,-2,0
    -2,2,0,0
    2,-2,0,-1
    1,-1,0,-1
    3,2,0,2
    INPUT
  examples << [<<~INPUT.strip, 8]
    1,-1,-1,-2
    -2,-2,0,1
    0,2,1,3
    -2,3,-2,1
    0,2,3,-2
    -1,-1,1,-2
    0,-2,-1,0
    -2,2,3,-1
    1,2,2,0
    -1,-2,0,-2
    INPUT

  examples.each do |input, expected|
    it "finds the correct number of constellations" do
      fp = FixedPoints.from_string(input)
      expect(fp.constellations.length).to eq expected
    end
  end
end
