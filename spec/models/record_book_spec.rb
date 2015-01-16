describe RecordBook do
  subject { described_class.new(DB) }

  it "finds all course records" do
    ron_jon_gold = subject.all_records.find{ |s| s[:id] == 16 }
    expect(ron_jon_gold[:id]).to eq 16
    expect(ron_jon_gold[:total]).to eq 20
    expect(ron_jon_gold[:holes]).to eq [2,4,2,3,1,3,1,2,2]
    expect(ron_jon_gold[:place]).to eq 1
    expect(ron_jon_gold[:player_id]).to eq 1
    expect(ron_jon_gold[:played_at]).to eq ::Time.parse("2012-08-16 20:59:00 -0600")
    expect(ron_jon_gold[:course_id]).to eq 1
  end

  it "returns 5 records per course (except 4 for Mulligan's Lighthouse)" do
    expect(subject.all_records.size).to eq(5 * 7 - 1)
  end

  it "excludes teams from records" do
    trafalga_gold = subject.records_by_course_id[8].first
    expect(trafalga_gold[:player_id]).to eq 12
  end
end
