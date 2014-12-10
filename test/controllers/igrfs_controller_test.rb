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
      after do
        @igrf.destroy
      end

      before do
        @igrf = InterleagueGameReportingForm.create(form: fixture_file_upload("igrfs/one.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))

        IgrfImport.stub_any_instance :save, true do
          InterleagueGameReportingForm.stub_any_instance :id, 1 do
            IgrfImport.stub_any_instance :igrf, @igrf do
              post :create
            end
          end
        end
      end

      it "returns HTTP redirect" do
        assert_response :redirect
      end

      it "redirects to IGRF" do
        assert_redirected_to "/igrfs/1"
      end
    end

    describe "on failure" do
      before do
        IgrfImport.stub_any_instance :save, false do
          post :create
        end
      end

      it "renders new" do
        assert_template :new
      end
    end
  end
end
