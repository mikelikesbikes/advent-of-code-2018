base = Path.expand("..", __ENV__.file)
Code.require_file("fabric_analyzer.exs", base)

input = File.read!(Path.expand("input.txt", base))
        |> String.split("\n", trim: true)

IO.puts FabricAnalyzer.overlap(input)
IO.puts FabricAnalyzer.pristine_claim(input)
