describe "/games/:id.json" do
  include Rack::Test::Methods

  def app; Golfscore; end

  it "returns a 200" do
    get "/games/1.json"
    expect(last_response.status).to eq 200
  end

  it "renders information about the game" do
    get "/games/1.json"
    game = JSON.parse(last_response.body)
    expect(game).to eq({
      "id" => 1,
      "course_id" => 1,
      "course" => "ron jon",
      "played_at" => 1345259700,
      "scores" => [
        {"id" => 1,"player_id" => 1,"holes" => [3,3,2,3,2,2,4,2,2],"name" => "Mikey"},
        {"id" => 2,"player_id" => 2,"holes" => [2,3,1,2,2,3,2,6,3],"name" => "jon"},
      ]})
  end
end
