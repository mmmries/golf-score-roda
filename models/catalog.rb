class Catalog
  attr_reader :db

  def initialize(db)
    @db = db
  end

  def find_by_id(course_id)
    course = DB.fetch("SELECT * FROM courses WHERE id = ?", course_id).first
    course["par"] = par_by_id(course_id)
    course["number_of_games_played"] = number_of_games_played_by_id(course_id)
    course["recent_games"] = recent_games_by_id(course_id)
    course["records"] = records_by_id(course_id)
    course
  end

  private

  def number_of_games_played_by_id(course_id)
    db.fetch("SELECT COUNT(*) AS cnt FROM games WHERE course_id = ?",course_id).first[:cnt]
  end

  def par_by_id(course_id)
    hole_attributes = (1..18).map{|i| ("hole%02d" % i).to_sym}
    scores = db.fetch("SELECT s.*
                       FROM scores AS s
                       INNER JOIN games AS g ON g.id = s.game_id
                       WHERE g.course_id = ?
                         AND (g.teams = 'f' OR g.teams IS NULL)", course_id).to_a
    scores.map!{|score| hole_attributes.map{|attr| score[attr]}.compact }
    holes = scores.transpose
    par = holes.map do |hole_scores|
      sum = hole_scores.reduce(0.0){|sum, score| sum + score}
      (sum / hole_scores.size).round
    end
  end

  def recent_games_by_id(course_id)
    games = db.fetch("SELECT *
                     FROM games
                     WHERE course_id = ?
                     ORDER BY played_at DESC LIMIT 10", course_id).to_a
    games.map{|g| {id: g[:id], played_at: g[:played_at].to_i} }
  end

  def records_by_id(course_id)
    attrs = %i( place id total course course_id game_id player player_id )
    all_records = RecordBook.new(db).records_by_course_id
    all_records[course_id].map do |record|
      Hash[attrs.zip(record.values_at(*attrs))].merge(:played_at => record[:played_at].to_i)
    end
  end
end
