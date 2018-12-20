require_relative "./day_19.rb"

describe Device do
  let(:input) do
    <<~'INPUT'.strip
      #ip 0
      seti 5 0 1
      seti 6 0 2
      addi 0 1 0
      addr 1 2 3
      setr 1 0 0
      seti 8 0 4
      seti 9 0 5
    INPUT
  end

  let(:device) { Device.load_program(input) }

  it "initializes the registers and instruction pointer" do
    expect(device.dump).to eq [0, [0, 0, 0, 0, 0, 0]]
  end

  describe "step" do
    it "executes instructions updating the state of the device" do
      device.step
      expect(device.dump).to eq [1, [0, 5, 0, 0, 0, 0]]

      device.step
      expect(device.dump).to eq [2, [1, 5, 6, 0, 0, 0]]

      device.step
      expect(device.dump).to eq [4, [3, 5, 6, 0, 0, 0]]

      device.step
      expect(device.dump).to eq [6, [5, 5, 6, 0, 0, 0]]

      device.step
      expect(device.dump).to eq [7, [6, 5, 6, 0, 0, 9]]
    end
  end

  describe "run" do
    it "runs until the instruction pointer is out of bounds" do
      device.run
      expect(device.dump).to eq [7, [6, 5, 6, 0, 0, 9]]
    end
  end
end
