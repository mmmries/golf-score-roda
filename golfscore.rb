require_relative "config/environment.rb"

class Golfscore < Roda
  route do |r|
    r.is "awesomest_players.json" do
      attrs = [:id, :name, :points]
      all_players = Directory.new(DB).all_players
      all_players = all_players.sort_by{|p| p[:points]}.reverse.take(10).map do |player|
        Hash[attrs.zip(player.values_at(*attrs))]
      end

      JSON.generate all_players
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

    r.is "players/:id.json" do |player_id|
      player = Directory.new(DB).player(player_id.to_i)
      player[:records].map! do |r|
        {:id => r[:id], :place => r[:place], :played_at => r[:played_at].to_i, :course => r[:course], :course_id => r[:course_id]}
      end

      JSON.generate(player)
    end
  end
end
