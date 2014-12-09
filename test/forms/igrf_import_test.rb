require "test_helper"

require "igrf"

describe IgrfImport do
  subject { IgrfImport }

  after do
    InterleagueGameReportingForm.destroy_all
  end

  before do
    @form = Rack::Test::UploadedFile.new(File.join("test", "fixtures", "igrfs", "one.xlsx"), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    @import = subject.new(form: @form)
  end

  it "isn't persisted" do
    assert_equal false, subject.new.persisted?
  end

  describe "with form" do
    before do
      Igrf.stub :for, Igrf::Workbook.new(Support::Igrf.file) do
        IgrfImporter::Game.stub_any_instance :imported?, false do
          IgrfImporter::Game.stub_any_instance :import, Game.new do
            @import.save
          end
        end
      end
    end

    it "creates an InterleagueGameReportingForm" do
      assert @import.igrf.is_a?(InterleagueGameReportingForm)
      assert_equal false, @import.igrf.new_record?
    end

    it "creates a Game" do
      assert @import.igrf.game.is_a?(Game)
    end
  end

  describe "with already imported Game" do
    before do
      game = Game.new

      Igrf.stub :for, Igrf::Workbook.new(Support::Igrf.file) do
        game.stub :igrf, InterleagueGameReportingForm.new do
          IgrfImporter::Game.stub_any_instance :imported?, true do
            @import.save
          end
        end
      end
    end

    it "doesn't create an InterleagueGameReportingForm" do
      assert_equal true, @import.igrf.new_record?
    end

    it "has an error" do
      assert_equal "Game already imported.", @import.errors.messages[:form].first
    end
  end

  describe "without form" do
    it "is invalid" do
      Igrf.stub :for, Igrf::Workbook.new(Support::Igrf.file) do
        assert_equal false, subject.new.valid?
      end
    end
  end
end
