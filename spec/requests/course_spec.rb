describe "/courses/:id.json" do
  include Rack::Test::Methods

  def app; Golfscore; end

  it "returns a 200"
  it "renders information about the course"
end
