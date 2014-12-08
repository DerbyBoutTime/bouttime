require "test_helper"

describe InterleagueGameReportingForm do
  let(:interleague_game_reporting_form) { InterleagueGameReportingForm.new(form: Rack::Test::UploadedFile.new(File.open(Support::Igrf.file))) }

  it "must be valid" do
    interleague_game_reporting_form.must_be :valid?
  end
end
