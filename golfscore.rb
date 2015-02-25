require_relative "config/environment.rb"

class Golfscore < Roda
  plugin :json

  route do |r|
    r.is "awesomest_players.json" do
      attrs = [:id, :name, :points]
      Directory.new(DB).all_players.sort_by{|p| p[:points]}.reverse.take(10).map do |player|
        Hash[attrs.zip(player.values_at(*attrs))]
      end
    end

    r.is "games/:id.json" do |id|
      hole_attributes = (1..18).map{|i| ("hole%02d" % i).to_sym}
      ds = DB.dataset.select_all(:g).select_append(:c__name)
      game = ds.from(:games___g).left_join(:courses___c, :id=>:course_id).first(:g__id=>id.to_i)
      scores = ds.from(:scores___g).left_join(:players___c, :id=>:player_id).where(:game_id=>id.to_i).map do |s|
        holes = hole_attributes.map{|attr| s[attr]}.compact
        {:id => s[:id], :player_id => s[:player_id], :name => s[:name], :holes => holes}
      end

      {
        :id => game[:id],
        :course_id => game[:course_id],
        :course => game[:name],
        :played_at => game[:played_at].to_i,
        :scores => scores,
      }
    end

    r.is "recent_games.json" do
      DB[:games___g].left_join(:courses___c, :id=>:course_id).select_all(:g).select_append(:c__name___course_name).reverse(:created_at).limit(10).map do |row|
        {
          :id => row[:id],
          :course_id => row[:course_id],
          :played_at => row[:played_at].to_i,
          :course => row[:course_name],
        }
      end
    end

    r.is "players/:id.json" do |player_id|
      player = Directory.new(DB).player(player_id.to_i)
      player[:records].map! do |r|
        {:id => r[:id], :place => r[:place], :played_at => r[:played_at].to_i, :course => r[:course], :course_id => r[:course_id]}
      end

      player
    end

    r.is "courses/:id.json" do |course_id|
      Catalog.new(DB).find_by_id(course_id.to_i)
    end
  end
end
