require_relative "./day_14.rb"

describe Kitchen do
  let(:input) do
    ""
  end

  it "ticks" do
    kitchen = Kitchen.new
    expect(kitchen.recipe_scores).to eq [3, 7]

    kitchen.tick

    expect(kitchen.recipe_scores).to eq [3, 7, 1, 0]

    kitchen.tick

    expect(kitchen.recipe_scores).to eq [3, 7, 1, 0, 1, 0]

    kitchen.make(19)
    expect(kitchen.recipe_scores.slice(9, 10)).to eq [5, 1, 5, 8, 9, 1, 6, 7, 7, 9]
  end

  it "finds the number of recipes before a score sequence" do
    expect(Kitchen.new.make_until_score_sequence("51589")).to eq 9
    expect(Kitchen.new.make_until_score_sequence("01245")).to eq 5
    expect(Kitchen.new.make_until_score_sequence("92510")).to eq 18
    expect(Kitchen.new.make_until_score_sequence("59414")).to eq 2018
  end
end
