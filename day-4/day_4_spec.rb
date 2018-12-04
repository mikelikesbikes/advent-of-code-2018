require_relative "./day_4"

describe ScheduleAnalyzer do
  let(:lines) do
    <<~INPUT.strip.split("\n")
      [1518-11-01 00:00] Guard #10 begins shift
      [1518-11-01 00:05] falls asleep
      [1518-11-01 00:25] wakes up
      [1518-11-01 00:30] falls asleep
      [1518-11-01 00:55] wakes up
      [1518-11-01 23:58] Guard #99 begins shift
      [1518-11-02 00:40] falls asleep
      [1518-11-02 00:50] wakes up
      [1518-11-03 00:05] Guard #10 begins shift
      [1518-11-03 00:24] falls asleep
      [1518-11-03 00:29] wakes up
      [1518-11-04 00:02] Guard #99 begins shift
      [1518-11-04 00:36] falls asleep
      [1518-11-04 00:46] wakes up
      [1518-11-05 00:03] Guard #99 begins shift
      [1518-11-05 00:45] falls asleep
      [1518-11-05 00:55] wakes up
      [1518-11-05 23:58] Guard #55 begins shift
    INPUT
  end

  it "selects the guard the sleeps the most" do
    expect(ScheduleAnalyzer.select_sleepiest_guard(lines)).to eq 240
  end

  it "selects the guard that sleeps at the same time most consistently" do
    expect(ScheduleAnalyzer.select_most_consistent_guard(lines)).to eq 4455
  end
end
