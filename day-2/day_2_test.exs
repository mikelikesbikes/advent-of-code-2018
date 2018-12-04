Code.require_file("../box_scanner.exs", __ENV__.file)

ExUnit.start()

defmodule DeviceTest do
  use ExUnit.Case

  test "checksum" do
    boxes = [
      "abcdef",
      "bababc",
      "abbcde",
      "abcccd",
      "aabcdd",
      "abcdee",
      "ababab",
    ]
    assert BoxScanner.checksum(boxes) == 12
  end

  test "similar" do
    boxes = [
      "abcde",
      "fghij",
      "klmno",
      "pqrst",
      "fguij",
      "axcye",
      "wvxyz"
    ]
    assert BoxScanner.similar(boxes) == "fgij"
  end
end
