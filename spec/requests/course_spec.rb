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
    expect(course["records"].first).to eq({
      "place" => 1,
      "id" => 42,
      "played_at" => 1346351940,
      "total" => 37,
      "course" => "trafalga",
      "course_id" => 2,
    })
    expect(course["recent_games"].size).to eq 9
    expect(course["recent_games"]).to include({
      "id" => 10,
      "played_at" => 1346351940,
    })
  end
end
