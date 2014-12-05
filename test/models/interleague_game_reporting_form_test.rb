require "test_helper"

describe InterleagueGameReportingForm do
  let(:interleague_game_reporting_form) { InterleagueGameReportingForm.new }

  it "must be valid" do
    interleague_game_reporting_form.must_be :valid?
  end
end
