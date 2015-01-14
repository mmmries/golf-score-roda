require_relative "config/environment.rb"

class Golfscore < Roda
  route do |r|
    r.is "awesomest_players.json" do
      player = DB.fetch("SELECT * FROM players WHERE id = 1").first
      JSON.generate([player])
    end
  end
end
