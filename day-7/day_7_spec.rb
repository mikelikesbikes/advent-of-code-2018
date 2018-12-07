require_relative "./day_7"

describe SleighIntstructionCollator do
  let(:input) do
    [
      "Step C must be finished before step A can begin.",
      "Step C must be finished before step F can begin.",
      "Step A must be finished before step B can begin.",
      "Step A must be finished before step D can begin.",
      "Step B must be finished before step E can begin.",
      "Step D must be finished before step E can begin.",
      "Step F must be finished before step E can begin."
    ]
  end

  it "determines work order" do
    expect(SleighIntstructionCollator.worked_order(input).first).to eq "CABDFE"
  end

  it "determines work order with multiple workers" do
    expect(SleighIntstructionCollator.worked_order(input, 2) { |w| w.ord - 'A'.ord + 1 }).to eq ["CABFDE", 15]
  end
end
