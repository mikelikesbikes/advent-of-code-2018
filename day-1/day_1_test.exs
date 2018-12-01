Code.require_file("device.exs", ".")

ExUnit.start()

defmodule DeviceTest do
  use ExUnit.Case

  test "frequency_shift" do
    assert Device.frequency_shift([+1, +1, +1]) == 3
    assert Device.frequency_shift([+1, +1, -2]) == 0
    assert Device.frequency_shift([-1, -2, -3]) == -6
    assert Device.frequency_shift([+1, -2, +3, +1]) == 3
  end

  test "calibrate" do
    assert Device.calibrate([+1, -2, +3, +1]) == 2
    assert Device.calibrate([+1, -1]) == 0
    assert Device.calibrate([+3, +3, +4, -2, -4]) == 10
    assert Device.calibrate([-6, +3, +8, +5, -6]) == 5
    assert Device.calibrate([+7, +7, -2, -7, -4]) == 14
  end
end
