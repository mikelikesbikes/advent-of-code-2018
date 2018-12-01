defmodule Device do
  def frequency_shift(deltas) do
    List.foldl(deltas, 0, fn (x, a) -> a + x end)
  end

  def calibrate(deltas) do
    calibrate(deltas, 0, MapSet.new([0]))
  end

  def calibrate([delta | deltas], current_frequency, frequencies) do
    new_frequency = current_frequency + delta
    if MapSet.member?(frequencies, new_frequency) do
      new_frequency
    else
      calibrate(
        deltas ++ [delta],
        new_frequency,
        MapSet.put(frequencies, new_frequency)
      )
    end
  end
end
