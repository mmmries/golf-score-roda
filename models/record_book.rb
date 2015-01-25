class RecordBook
  attr_reader :db

  def initialize(db)
    @db = db
  end

  def all_records
    records_by_course_id.inject([]) do |list, pair|
      list + pair.last
    end
  end

  def records_by_course_id
    @records_by_course_id ||= begin
      hole_attributes = (1..18).map{|i| ("hole%02d" % i).to_sym}
      scores = db.fetch("SELECT
                          s.*,
                          g.id AS game_id,
                          g.course_id,
                          g.played_at,
                          c.name AS course,
                          p.name AS player,
                          p.id AS player_id
                         FROM scores AS s
                         LEFT JOIN games AS g on g.id = s.game_id
                         LEFT JOIN courses AS c on c.id = g.course_id
                         LEFT JOIN players AS p ON p.id = s.player_id
                         WHERE g.teams = 'f' OR g.teams IS NULL").to_a
      scores.each do |score|
        score[:holes] = hole_attributes.map{|attr| score[attr]}.compact
        score[:total] = score[:holes].reduce(0, &:+)
      end
      scores.sort_by!{|s| [s[:total], s[:played_at], s[:player_id]] }
      records_by_course_id = scores.group_by{|s| s[:course_id] }.map do |course_id, scores|
        records = scores.take(5)
        records.each_with_index do |score, index|
          score[:place] = index + 1
        end
        [course_id, records]
      end
      Hash[records_by_course_id]
    end
  end
end
