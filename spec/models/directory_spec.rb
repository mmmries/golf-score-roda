describe Directory do
  subject { described_class.new(DB) }

  it "returns a list of all players with their cumulative scores" do
    mikey = subject.all_players.first
    expect(mikey[:id]).to eq 1
    expect(mikey[:points]).to eq 63
    expect(mikey[:name]).to eq "Mikey"
  end

  it "looks up a specific user with their associated records" do
    mikey = subject.player(1)
    expect(mikey[:id]).to eq 1
    expect(mikey[:points]).to eq 63
    expect(mikey[:name]).to eq "Mikey"
    expect(mikey[:records]).to be_a Array
    record = mikey[:records].first
    expect(record[:place]).to eq 1
    expect(record[:id]).to eq 16
    expect(record[:played_at]).to eq ::Time.parse("2012-08-16 20:59:00-0600")
    expect(record[:course]).to eq "ron jon"
    expect(record[:course_id]).to eq 1
  end
end
