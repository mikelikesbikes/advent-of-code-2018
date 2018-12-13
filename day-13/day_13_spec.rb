require_relative "./day_13.rb"

describe Railway do
  let(:input) do
    ""
  end

  it "navigates a loop" do
    input = <<~'INPUT'
      /->-\
      |   |
      \---/
    INPUT

    railway = Railway.from_string(input)
    car = railway.cars[0]
    expect(car.position).to eq [2, 0]
    2.times { railway.tick }
    expect(car.position).to eq [4, 0]
    railway.tick
    expect(car.position).to eq [4, 1]
    expect(car.direction).to eq "v"
    9.times { railway.tick }
    expect(car.position).to eq [2, 0]
    expect(car.direction).to eq ">"
  end

  it "calculates the position of the first crash" do
    input = <<~'INPUT'
      |
      v
      |
      |
      |
      ^
      |
    INPUT

    expect(Railway.from_string(input).first_crash_location).to eq [0,3]
  end

  it "calculates the position of the first crash again" do
    input = <<~'INPUT'
      /->-\
      |   |  /----\
      | /-+--+-\  |
      | | |  | v  |
      \-+-/  \-+--/
        \------/
    INPUT

    expect(Railway.from_string(input).first_crash_location).to eq [7,3]
  end

  it "finds the position of the last cart" do
    input = <<~'INPUT'
      />-<\
      |   |
      | /<+-\
      | | | v
      \>+</ |
        |   ^
        \<->/
    INPUT
    expect(Railway.from_string(input).last_car_location).to eq [6,4]
  end

end
