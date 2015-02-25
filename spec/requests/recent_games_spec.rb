describe "/recent_games.json" do
  include Rack::Test::Methods

  def app
    Golfscore
  end

  it "returns a 200" do
    get "/recent_games.json"
    expect(last_response.status).to eq 200
  end

  it "renders a list of games" do
    get "/recent_games.json"
    games = JSON.parse(last_response.body)
    expect(games.first).to eq({
      "id" => 27,
      "course" => "Trafalga Orem Lighthouse",
      "course_id" => 8,
      "played_at" => Time.parse("2013-09-06 14:01:00").to_i,
    })
  end
end
