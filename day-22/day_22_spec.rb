require_relative "./day_22.rb"

describe CaveAnalyzer do
  let(:analyzer) { CaveAnalyzer.new(510, [10, 10]) }
  describe "geologic_index" do
    [
      [[0, 0], 0],
      [[10, 10], 0],
      [[1, 0], 16807],
      [[0, 1], 48271],
      [[1, 1], 145722555]
    ].each do |coord, expected|
      it "is #{expected} at #{coord.inspect}" do
        expect(analyzer.geologic_index(*coord)).to eq expected
      end
    end
  end

  describe "erosion_level/type" do
    [
      [[0, 0], :rocky],
      [[10, 10], :rocky],
      [[1, 0], :wet],
      [[0, 1], :rocky],
      [[1, 1], :narrow]
    ].each do |coord, expected|
      it "is #{expected} at #{coord.inspect}" do
        expect(analyzer.type(*coord)).to eq expected
      end
    end
  end

  it "has a risk level of 114" do
    expect(analyzer.risk_level).to eq 114
  end

  it "finds the fastest route" do
    expect(analyzer.fastest_route).to eq 45
  end
end
