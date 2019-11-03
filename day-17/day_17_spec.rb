require_relative "./day_17.rb"

describe Diviner do
  let(:input) do
    <<~INPUT.strip
      x=495, y=2..7
      y=7, x=495..501
      x=501, y=3..7
      x=498, y=2..4
      x=506, y=1..2
      x=498, y=10..13
      x=504, y=10..13
      y=13, x=498..504
    INPUT
  end

  it "fills upwards" do
    diviner = Diviner.from_string(input)
    expect(diviner.to_s).to eq <<~EXPECTED.strip
      ......+.......
      ......|.....#.
      .#..#||||...#.
      .#..#~~#|.....
      .#..#~~#|.....
      .#~~~~~#|.....
      .#~~~~~#|.....
      .#######|.....
      ........|.....
      ...|||||||||..
      ...|#~~~~~#|..
      ...|#~~~~~#|..
      ...|#~~~~~#|..
      ...|#######|..
    EXPECTED

    expect(diviner.water_capacity).to eq 57
    expect(diviner.retained_capacity).to eq 29
  end

  it "fills around" do
    diviner = Diviner.from_string(<<~INPUT.strip)
      x=495, y=2..7
      x=505, y=2..7
      y=7, x=495..505
      x=498, y=3..4
      x=502, y=3..4
      y=5, x=498..502
    INPUT

    expect(diviner.to_s).to eq <<~EXPECTED.strip
     ......+......
     |||||||||||||
     |#~~~~~~~~~#|
     |#~~#~~~#~~#|
     |#~~#~~~#~~#|
     |#~~#####~~#|
     |#~~~~~~~~~#|
     |###########|
    EXPECTED

    diviner = Diviner.from_string(<<~INPUT.strip)
      x=498, y=2..7
      x=508, y=2..7
      y=7, x=498..508
      x=501, y=3..4
      x=505, y=3..4
      y=5, x=501..505
    INPUT

    expect(diviner.to_s).to eq <<~EXPECTED.strip
     ...+.........
     |||||||||||||
     |#~~~~~~~~~#|
     |#~~#~~~#~~#|
     |#~~#~~~#~~#|
     |#~~#####~~#|
     |#~~~~~~~~~#|
     |###########|
    EXPECTED
  end

  it "doesn't fill between streams" do
    diviner = Diviner.from_string(<<~INPUT.strip)
      y=2, x=498..502
      x=496, y=5..6
      x=498, y=5..6
      y=6, x=496..498
      x=502, y=5..6
      x=504, y=5..6
      y=6, x=502..504
      x=494, y=9..10
      x=506, y=9..10
      y=10, x=494..506
    INPUT

    expect(diviner.to_s).to eq <<~EXPECTED.strip
      .......+.......
      ....|||||||....
      ....|#####|....
      ....|.....|....
      ..|||||.|||||..
      ..|#~#|.|#~#|..
      ..|###|.|###|..
      ..|...|.|...|..
      |||||||||||||||
      |#~~~~~~~~~~~#|
      |#############|
    EXPECTED
  end
end
