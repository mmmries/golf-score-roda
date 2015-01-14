require_relative "config/environment.rb"

class Golfscore < Roda
  route do |r|
    r.is "awesomest_players.json" do
      player = DB.fetch("SELECT * FROM players WHERE id = 1").first
      JSON.generate([player])
    end

    r.is "recent_games.json" do
      recent_games = DB.fetch("SELECT g.*, c.name AS course_name FROM games AS g LEFT JOIN courses AS c ON c.id = g.course_id ORDER BY created_at DESC LIMIT 10").to_a
      recent_games.map! do |row|
        {
          :id => row[:id],
          :course_id => row[:course_id],
          :played_at => row[:played_at].to_i,
          :course => row[:course_name],
        }
      end
      JSON.generate(recent_games)
    end
  end
end
