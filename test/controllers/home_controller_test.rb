require "test_helper"

describe HomeController do
  describe "GET index" do
    it "returns http success" do
      get :index
      assert_response :success
    end
  end
end
