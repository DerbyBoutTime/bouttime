require "test_helper"

describe IgrfsController do
  describe "GET new" do
    before do
      get :new
    end

    it "returns HTTP success" do
      assert_response :success
    end

    it "renders new" do
      assert_template :new
    end
  end

  describe "POST create" do
    describe "on success" do
      before do
        InterleagueGameReportingForm.stub_any_instance :id, 1 do
          IgrfImporter.stub :import, Game.new do
            post :create, interleague_game_reporting_form: { form: fixture_file_upload("igrfs/one.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") }
          end
        end
      end

      it "returns HTTP redirect" do
        assert_response :redirect
      end

      it "redirects to IGRF" do
        assert_redirected_to "/igrfs/1"
      end

      after do
        InterleagueGameReportingForm.destroy_all
      end
    end

    describe "on failure" do
      before do
        post :create
      end

      it "renders new" do
        assert_template :new
      end
    end
  end
end
