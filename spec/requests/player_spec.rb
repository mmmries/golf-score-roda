describe "/players/:id.json" do
  include Rack::Test::Methods

  def app; Golfscore; end

  it "returns a 200" do
    get "/players/1.json"
    expect(last_response.status).to eq 200
  end

  it "renders some player information" do
    get "/players/1.json"
    player = JSON.parse(last_response.body)
    expect(player["id"]).to eq 1
    expect(player["name"]).to eq "Mikey"
    expect(player["points"]).to eq 63
    expect(player["records"]).to be_a(Array)
    expect(player["records"]).to include({
      "place" => 1,
      "id" => 16,
      "played_at" => "1345150740",
      "course" => "ron jon",
      "course_id" => 1,
    })
  end
end
