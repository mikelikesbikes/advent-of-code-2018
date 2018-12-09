require_relative "./day_9.rb"

describe MarbleGame do
  describe "winning_score"

  [
    [[9, 25], 32],
    [[9, 250], 361],
    [[10, 1618], 8317],
    [[10, 16180], 756228],
    [[13, 7999], 146373],
    [[13, 79990], 14192579],
    [[17, 1104], 2764],
    [[17, 11040], 214885],
    [[21, 6111], 54718],
    [[21, 61110], 5135559],
    [[30, 5807], 37305],
    [[30, 58070], 3263404]
  ].each do |(n, value), high_score|
    it "returns #{high_score} for #{n} players, last marble #{value}" do
      game = MarbleGame.new(n, value)
      expect(game.winning_score).to eq high_score
    end
  end
end
