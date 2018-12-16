require_relative "./day_16.rb"

describe ChronalBytecode do
  describe "potential_instructions" do
    it "returns instructions that match the observations" do
      before = [3, 2, 1, 1]
      after = [3, 2, 2, 1]
      bytecode = "9 2 1 2"

      expect(ChronalBytecode.potential_instructions(bytecode, before, after))
        .to eq %i[ addi mulr seti ]
    end
  end

  describe "analyze_observations" do
    it "finds the number of examples that have 3 or more potential opcode behaviors" do
      input = <<~INPUT.strip
        Before: [3, 2, 1, 1]
        9 2 1 2
        After:  [3, 2, 2, 1]

        Before: [3, 2, 1, 1]
        9 2 1 2
        After:  [3, 2, 2, 1]
      INPUT

      expect(ChronalBytecode.analyze_observations(input) { |obs| obs.count { |_, p| p.length >= 3 } }).to eq 2
    end
  end
end
