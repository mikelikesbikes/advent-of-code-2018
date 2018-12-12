require_relative "./day_12.rb"

describe Garden do
  let(:input) do
    <<~INPUT
      initial state: #..#.#..##......###...###

      ...## => #
      ..#.. => #
      .#... => #
      .#.#. => #
      .#.## => #
      .##.. => #
      .#### => #
      #.#.# => #
      #.### => #
      ##.#. => #
      ##.## => #
      ###.. => #
      ###.# => #
      ####. => #"
    INPUT
  end

  it "computes the state after n generations" do
    expect(Garden.from_input(input).live_plants).to eq [0, 3, 5, 8, 9, 16, 17, 18, 22, 23, 24]
    expect(Garden.from_input(input).tick.live_plants).to eq [0, 4, 9, 15, 18, 21, 24]
    expect(Garden.from_input(input).tick(2).live_plants).to eq [0, 1, 4, 5, 9, 10, 15, 18, 21, 24, 25]
    expect(Garden.from_input(input).tick(20).live_plants).to eq [-2, 3, 4, 9, 10, 11, 12, 13, 17, 18, 19, 20, 21, 22, 23, 28, 30, 33, 34]
  end

  it "computes the sum after n generations" do
    expect(Garden.from_input(input).sum_after_tick(20)).to eq 325
    expect(Garden.from_input(input).sum_after_tick(50_000_000_000)).to eq 999999999374
  end
end
