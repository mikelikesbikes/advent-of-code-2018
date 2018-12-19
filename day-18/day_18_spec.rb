require_relative "./day_18.rb"

describe Settlement do
  let(:input) do
    <<~INPUT.strip
      .#.#...|#.
      .....#|##|
      .|..|...#.
      ..|#.....#
      #.#|||#|#|
      ...#.||...
      .|....|...
      ||...#|.#|
      |.||||..|.
      ...#.|..|.
    INPUT
  end

  let(:settlement) { Settlement.from_string(input) }

  it "initializes from a string" do
    expect(settlement.to_s).to eq input
  end

  it "ticks" do
    settlement.tick
    expect(settlement.to_s).to eq <<~EXPECTED.strip
      .......##.
      ......|###
      .|..|...#.
      ..|#||...#
      ..##||.|#|
      ...#||||..
      ||...|||..
      |||||.||.|
      ||||||||||
      ....||..|.
    EXPECTED

    settlement.tick
    expect(settlement.to_s).to eq <<~EXPECTED.strip
      .......#..
      ......|#..
      .|.|||....
      ..##|||..#
      ..###|||#|
      ...#|||||.
      |||||||||.
      ||||||||||
      ||||||||||
      .|||||||||
    EXPECTED

    8.times { settlement.tick }
    expect(settlement.to_s).to eq <<~EXPECTED.strip
      .||##.....
      ||###.....
      ||##......
      |##.....##
      |##.....##
      |##....##|
      ||##.####|
      ||#####|||
      ||||#|||||
      ||||||||||
    EXPECTED
  end

  it "calculates resource value" do
    10.times { settlement.tick }
    expect(settlement.resource_value).to eq 1147
  end
end
