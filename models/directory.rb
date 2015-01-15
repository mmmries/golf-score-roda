class Directory
  def initialize(db)
    @db = db
  end

  def all_players
    @all_players ||= begin
      players = db.fetch("SELECT * FROM players").to_a
      players.each do |player|
        player[:points] = points_for_player_id(player[:id])
      end
      players
    end
  end

  private
  attr_reader :db

  def all_records
    @all_records ||= RecordBook.new(db).all_records
  end

  def points_for_player_id(id)
    scores = score_count_by_player_id.fetch(id, 0)
    record_places = all_records.select{|r| r[:player_id] == id}.map{|r| r[:place]}
    record_points = record_places.map{|place|
      case place
        when 1; 10
        when 2; 5
        when 3; 3
        else; 1
      end
    }
    scores + record_points.reduce(0, &:+)
  end

  def score_count_by_player_id
    @game_count_by_player_id ||= begin
      counts = db.fetch("SELECT COUNT(*) AS cnt, player_id FROM scores GROUP BY player_id").to_a
      counts.inject({}) do |hash, row|
        hash[row[:player_id]] = row[:cnt]
        hash
      end
    end
  end
end
