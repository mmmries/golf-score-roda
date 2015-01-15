describe Directory do
  subject { described_class.new(DB) }

  it "returns a list of all players with their cumulative scores" do
    mikey = subject.all_players.first
    expect(mikey[:id]).to eq 1
    expect(mikey[:points]).to eq 63
    expect(mikey[:name]).to eq "Mikey"
  end
end
