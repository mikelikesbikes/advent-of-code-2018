require_relative "./day_15.rb"

describe BeverageCombat do
  let(:input) do
    ""
  end

  examples = <<~MAP.strip.split("\n\n").each_slice(2)
    #######
    #.E...#
    #.....#
    #...G.#
    #######

    #######
    #..E..#
    #...G.#
    #.....#
    #######

    #######
    #E..G.#
    #...#.#
    #.G.#G#
    #######

    #######
    #.EG..#
    #.G.#.#
    #...#G#
    #######

    #########
    #G..G..G#
    #.......#
    #.......#
    #G..E..G#
    #.......#
    #.......#
    #G..G..G#
    #########

    #########
    #.G...G.#
    #...G...#
    #...E..G#
    #.G.....#
    #.......#
    #G..G..G#
    #.......#
    #########

    #########
    #.G...G.#
    #...G...#
    #...E..G#
    #.G.....#
    #.......#
    #G..G..G#
    #.......#
    #########

    #########
    #..G.G..#
    #...G...#
    #.G.E.G.#
    #.......#
    #G..G..G#
    #.......#
    #.......#
    #########

    #########
    #..G.G..#
    #...G...#
    #.G.E.G.#
    #.......#
    #G..G..G#
    #.......#
    #.......#
    #########

    #########
    #.......#
    #..GGG..#
    #..GEG..#
    #G..G...#
    #......G#
    #.......#
    #.......#
    #########

    #######
    #...G.#
    #..G.G#
    #.#.#G#
    #...#E#
    #.....#
    #######

    #######
    #..G..#
    #...G.#
    #.#G#G#
    #...#E#
    #.....#
    #######
  MAP

  examples.each do |input, expected|
    it "moves units in each round" do
      combat = BeverageCombat.from_string(input)

      expect { combat.round }
        .to change { combat.to_s }
        .from(input)
        .to(expected)
    end
  end

  examples = <<~INPUT.strip.split("\n\n").each_slice(2)
    #######
    #.G...#
    #...EG#
    #.#.#G#
    #..G#E#
    #.....#
    #######

    27730

    #######
    #G..#E#
    #E#E.E#
    #G.##.#
    #...#E#
    #...E.#
    #######

    36334

    #######
    #E..EG#
    #.#G.E#
    #E.##E#
    #G..#.#
    #..E#.#
    #######

    39514

    #######
    #E.G#.#
    #.#G..#
    #G.#.G#
    #G..#.#
    #...E.#
    #######

    27755

    #######
    #.E...#
    #.#..G#
    #.###.#
    #E#G#G#
    #...#G#
    #######

    28944

    #########
    #G......#
    #.E.#...#
    #..##..G#
    #...##..#
    #...#...#
    #.G...G.#
    #.....G.#
    #########

    18740
  INPUT

  examples.each do |input, expected_outcome|
    it "calculates the final outcome of a battle" do
      expect(BeverageCombat.from_string(input).outcome).to eq expected_outcome.to_i
    end
  end

  examples = <<~INPUT.strip.split("\n\n").each_slice(2)
#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######

4988

#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######

31284

#######
#E.G#.#
#.#G..#
#G.#.G#
#G..#.#
#...E.#
#######

3478

#######
#.E...#
#.#..G#
#.###.#
#E#G#G#
#...#G#
#######

6474

#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########

1140
  INPUT

  examples.each do |input, expected_outcome|
    it "calculates the final outcome of a battle" do
      expect(BeverageCombat.flawless_outcome(input)).to eq expected_outcome.to_i
    end
  end
end

