base = Path.expand("..", __ENV__.file)
Code.require_file("box_scanner.exs", base)

input = File.read!(Path.expand("input.txt", base))
        |> String.split("\n", trim: true)

IO.puts BoxScanner.checksum(input)
IO.puts BoxScanner.similar(input)
