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
      scores = db[:scores___s].
        left_join(:games___g, :id=>:game_id).
        left_join(:courses___c, :id=>:course_id).
        left_join(:players___p, :id=>:s__player_id).
        where(:g__teams=>'f').
        or(:g__teams=>nil).
        select_all(:s).
        select_append(
          :g__id___game_id,
          :g__course_id,
          :g__played_at,
          :c__name___course,
          :p__name___player,
          :p__id___player_id
        ).map do |score|
        score[:holes] = hole_attributes.map{|attr| score[attr]}.compact
        score[:total] = score[:holes].reduce(0, &:+)
        score
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
