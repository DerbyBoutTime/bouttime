require "test_helper"

describe ScoreboardController do
  describe "GET show" do
    it "returns http success" do
      get :show
      assert_response :success
    end
  end
end
