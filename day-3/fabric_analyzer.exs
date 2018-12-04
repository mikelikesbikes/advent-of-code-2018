defmodule FabricAnalyzer do
  def overlap(claims) do
    Enum.map(claims, &parse_claim(&1))
    |> overlap_map()
    |> Enum.count(fn {_coord, count} -> count > 1 end)
  end

  def pristine_claim(claims) do
    claims = Enum.map(claims, &parse_claim(&1))
    map = overlap_map(claims)

    pristine_claim(claims, map)
  end

  defp pristine_claim([{claim_id, coords} | rest], map) do
    if Enum.all?(coords, fn (coord) -> Map.get(map, coord) == 1 end) do
      claim_id
    else
      pristine_claim(rest, map)
    end
  end

  defp overlap_map(claims) when is_list(claims) do
    Enum.reduce(claims, %{}, fn ({_claim_id, coords}, acc) ->
      Enum.reduce(coords, acc, fn (coord, acc) ->
        Map.update(acc, coord, 1, fn x -> x + 1 end)
      end)
    end)
  end

  defp parse_claim(claim) do
    {claim_id, _sym, start, dimensions} = claim |> String.split(" ") |> List.to_tuple()
    claim_id = String.slice(claim_id, 1..-1)
    {x0, y0} = start |> String.slice(0..-2) |> String.split(",") |> Enum.map(&String.to_integer(&1)) |> List.to_tuple()
    {w, l} = dimensions |> String.split("x") |> Enum.map(&String.to_integer(&1)) |> List.to_tuple()
    coords = Enum.reduce(x0..(x0 + w - 1), [], fn (x, coords) ->
      Enum.reduce(y0..(y0 + l - 1), coords, fn (y, coords) ->
        [{x, y} | coords]
      end)
    end)
    {claim_id, coords}
  end
end
