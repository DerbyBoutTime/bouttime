require "test_helper"

describe EventsController do
  it "should get generic" do
    get :generic
    assert_response :success
  end

end
