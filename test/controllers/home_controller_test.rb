require "test_helper"

describe HomeController do
  describe "GET jam_timer" do
    it "returns http success" do
      get :jam_timer
      assert_response :success
    end
  end
  describe "GET lineup_tracker" do
    it "returns http success" do
      get :lineup_tracker
      assert_response :success
    end
  end
  describe "GET penalty_box" do
    it "returns http success" do
      get :penalty_box
      assert_response :success
    end
  end
  describe "GET penalty_tracker" do
    it "returns http success" do
      get :penalty_tracker
      assert_response :success
    end
  end
  describe "GET scorekeeper" do
    it "returns http success" do
      get :scorekeeper
      assert_response :success
    end
  end
  describe "GET scoreboard" do
    it "returns http success" do
      get :scoreboard
      assert_response :success
    end
  end
  describe "GET penalty_whiteboard" do
    it "returns http success" do
      get :penalty_whiteboard
      assert_response :success
    end
  end
  describe "GET announcer" do
    it "returns http success" do
      get :announcer
      assert_response :success
    end
  end
  describe "GET global_bout_notes" do
    it "returns http success" do
      get :global_bout_notes
      assert_response :success
    end
  end
end
