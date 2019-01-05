require_relative "./day_24.rb"

describe ImmuneSystem do
  let(:input) do
    <<~INPUT.strip
      Immune System:
      17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
      989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3

      Infection:
      801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
      4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4
    INPUT
  end

  let(:immune_system) { ImmuneSystem.from_string(input) }

  it "parses properly" do
    im1, im2 = immune_system.immune_system.groups
    in1, in2 = immune_system.infection.groups

    expect(im1.weaknesses).to eq ["radiation", "bludgeoning"]
    expect(im1.immunities).to be_empty
    expect(im2.weaknesses).to eq ["bludgeoning", "slashing"]
    expect(im2.immunities).to eq ["fire"]

    expect(in1.weaknesses).to eq ["radiation"]
    expect(in1.immunities).to be_empty
    expect(in2.weaknesses).to eq ["fire", "cold"]
    expect(in2.immunities).to eq ["radiation"]
  end

  it "returns the winning_army_size after fully playing out the battle" do
    expect(immune_system.winning_army_size).to eq 5216
  end

  it "steps through each combat round" do
    immune_system.step

    expect(immune_system.immune_system.groups.length).to eq 1
    expect(immune_system.immune_system.groups.first.units).to eq 905

    expect(immune_system.infection.groups.length).to eq 2
    expect(immune_system.infection.groups.first.units).to eq 797
    expect(immune_system.infection.groups.last.units).to eq 4434

    immune_system.step

    expect(immune_system.immune_system.groups.length).to eq 1
    expect(immune_system.immune_system.groups.first.units).to eq 761

    expect(immune_system.infection.groups.length).to eq 2
    expect(immune_system.infection.groups.first.units).to eq 793
    expect(immune_system.infection.groups.last.units).to eq 4434

    immune_system.step

    expect(immune_system.immune_system.groups.length).to eq 1
    expect(immune_system.immune_system.groups.first.units).to eq 618

    expect(immune_system.infection.groups.length).to eq 2
    expect(immune_system.infection.groups.first.units).to eq 789
    expect(immune_system.infection.groups.last.units).to eq 4434

    5.times { immune_system.step }

    expect(immune_system.immune_system.groups).to be_empty

    expect(immune_system.infection.groups.length).to eq 2
    expect(immune_system.infection.groups.first.units).to eq 782
    expect(immune_system.infection.groups.last.units).to eq 4434
  end

  it "boosts the immune_system by a given factor" do
    immune_system.boost(1570)

    immune_system.step

    expect(immune_system.immune_system.groups.map(&:units)).to eq [8, 905]
    expect(immune_system.infection.groups.map(&:units)).to eq [466, 4453]

    immune_system.step

    expect(immune_system.immune_system.groups.map(&:units)).to eq [876]
    expect(immune_system.infection.groups.map(&:units)).to eq [160, 4453]

    30.times { immune_system.step }

    expect(immune_system.immune_system.groups.map(&:units)).to eq [64]
    expect(immune_system.infection.groups.map(&:units)).to eq [19, 214]

    immune_system.step

    expect(immune_system.immune_system.groups.map(&:units)).to eq [60]
    expect(immune_system.infection.groups.map(&:units)).to eq [19, 182]

    immune_system.step

    expect(immune_system.immune_system.groups.map(&:units)).to eq [60]
    expect(immune_system.infection.groups.map(&:units)).to eq [182]

    5.times { immune_system.step }

    expect(immune_system.immune_system.groups.map(&:units)).to eq [51]
    expect(immune_system.infection.groups.map(&:units)).to eq [40]

    immune_system.step

    expect(immune_system.immune_system.groups.map(&:units)).to eq [51]
    expect(immune_system.infection.groups.map(&:units)).to eq [13]

    immune_system.step

    expect(immune_system.immune_system.groups.map(&:units)).to eq [51]
    expect(immune_system.infection.groups).to be_empty

    expect(immune_system.winning_army_size).to eq 51
  end
end
