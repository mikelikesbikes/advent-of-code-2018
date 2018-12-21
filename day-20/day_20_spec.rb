require_relative "./day_20.rb"

describe NorthPole::Map do
  let(:input) do

  end

  # E
  #   N
  #   S
  #   E
  #
  # ESSWWN          => 6
  #   E             => 1
  #   NNENN         => 5
  #     EESSSSS     => 7
  #     WWWSSSSE    => 8
  #       SW        => 2
  #       NNNE      => 4
  #
  # WSSEESWWWNW     => 11
  #   S             => 1
  #   NENNEEEENN    => 10
  #     ESSSSW      => 6
  #       NWSW      => 4
  #       SSEN      => 4
  #     WSWWN       => 5
  #       E         => 1
  #       WWS       => 3
  #         E       => 1
  #         SS      => 2

  [
    ["^E(N|S|E)$", 2, 2, 3],
    ["^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$", 23, 21, 4],
    ["^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$", 31, 30, 7]
  ].each do |regex, max_distance, min_doors, count_reachable|
    describe regex do
      let(:map) { NorthPole::Map.from_regex(regex.dup) }

      it "calculates the number of doors to the furthest room" do
        expect(map.longest_path).to eq max_distance
      end

      it "calculates the number of rooms that take at least #{min_doors} doors to get to" do
        expect(map.paths_with_at_least_n_steps(min_doors)).to eq count_reachable
      end
    end
  end
end
