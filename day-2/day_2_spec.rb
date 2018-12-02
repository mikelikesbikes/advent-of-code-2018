require "rspec"
require_relative "./day_2"

describe BoxScanner do
  it "calculates a checksum" do
    boxes = %w[
      abcdef
      bababc
      abbcde
      abcccd
      aabcdd
      abcdee
      ababab
    ]
    expect(BoxScanner.checksum(boxes)).to eq 12
  end

  it "finds common boxes" do
    boxes = %w[
      abcde
      fghij
      klmno
      pqrst
      fguij
      axcye
      wvxyz
    ]
    expect(BoxScanner.common_boxes(boxes)).to eq %w[fghij fguij]
    expect(BoxScanner.common_letters(boxes)).to eq "fgij"
  end
end
