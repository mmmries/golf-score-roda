describe "/courses/:id.json" do
  include Rack::Test::Methods

  def app; Golfscore; end

  it "returns a 200" do
    get "/courses/1.json"
    expect(last_response.status).to eq 200
  end

  it "renders information about the course" do
    get "/courses/2.json"
    course = JSON.parse(last_response.body)
    expect(course["id"]).to eq 2
    expect(course["name"]).to eq "trafalga"
    expect(course["par"]).to eq [3,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
    expect(course["number_of_games_played"]).to eq 9

    expect(course["records"].size).to eq 5
    top_record = course["records"].first
    expect(top_record["place"]).to eq 1
    expect(top_record["id"]).to eq 42
    expect(top_record["played_at"]).to eq Time.parse('2012-08-30 12:39:00').to_i
    expect(top_record["total"]).to eq 37
    expect(top_record["game_id"]).to eq 10
    expect(top_record["player"]).to eq "mattd"
    expect(top_record["player_id"]).to eq 4

    expect(course["recent_games"].size).to eq 9
    expect(course["recent_games"]).to include({
      "id" => 10,
      "played_at" => Time.parse('2012-08-30 12:39:00').to_i
    })
  end
end
