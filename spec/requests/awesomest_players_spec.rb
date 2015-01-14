describe "/awesomest_players.json" do
  include Rack::Test::Methods

  def app
    Golfscore
  end

  it "returns a 200" do
    get "/awesomest_players.json"
    expect(last_response.status).to eq 200
  end

  it "renders a list of players" do
    get "/awesomest_players.json"
    players = JSON.parse(last_response.body)
    expect(players.first).to eq({
      "id" => 1,
      "name" => "Mikey",
      "points" => 63,
    })
  end
end
