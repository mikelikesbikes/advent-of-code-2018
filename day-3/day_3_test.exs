Code.require_file("../fabric_analyzer.exs", __ENV__.file)

ExUnit.start()

defmodule FabricAnalyzerTest do
  use ExUnit.Case

  test "overlap" do
    claims = [
      "#1 @ 1,3: 4x4",
      "#2 @ 3,1: 4x4",
      "#3 @ 5,5: 2x2"
    ]
    assert FabricAnalyzer.overlap(claims) == 4
  end

  test "pristine_claim" do
    claims = [
      "#1 @ 1,3: 4x4",
      "#2 @ 3,1: 4x4",
      "#3 @ 5,5: 2x2"
    ]
    assert FabricAnalyzer.pristine_claim(claims) == "3"
  end
end
