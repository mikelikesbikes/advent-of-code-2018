defmodule BoxScanner do
  def checksum(boxes) do
    boxes = Enum.map(boxes, &String.to_charlist(&1))
    {twos, threes} =
      Enum.reduce(boxes, {0 ,0}, fn (box, {total_twos, total_threes}) ->
        {twos, threes} = box |> count_characters() |> count_twos_and_threes()
        {total_twos + twos, total_threes + threes}
      end)
    twos * threes
  end

  def similar(boxes) do
    boxes = Enum.map(boxes, &String.to_charlist(&1))
    find_similar(boxes)
    |> drop_diffs
    |> List.to_string
  end

  defp drop_diffs({left, right}) do
    Enum.zip(left, right)
    |> Enum.reduce([], fn
         {c, c}, acc -> acc ++ [c]
         _, acc -> acc
       end)
  end

  defp find_similar([box | rest]) do
    similar = Enum.find(rest, fn other -> one_diff?(box, other) end)
    if similar do
      {box, similar}
    else
      find_similar(rest)
    end
  end

  defp one_diff?(left, right) do
    diffs = Enum.zip(left, right)
    |> Enum.reduce(0, fn
         {c, c}, acc -> acc
         _, acc -> acc + 1
       end)
    diffs == 1
  end

  defp count_characters(string) do
    count_characters(string, %{})
  end

  defp count_characters([head | tail], acc) do
    acc = Map.update(acc, head, 1, fn x -> x + 1 end)
    count_characters(tail, acc)
  end

  defp count_characters([], acc) do
    acc
  end

  defp count_twos_and_threes(counts) do
    Enum.reduce(counts, {0, 0}, fn
      {_cp, 2}, {_twos, threes} -> {1, threes}
      {_cp, 3}, {twos, _threes} -> {twos, 1}
      _, acc -> acc
    end)
  end
end

