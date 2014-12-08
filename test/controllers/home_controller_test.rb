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
  describe "GET penalty_box_timer" do
    it "returns http success" do
      get :penalty_box_timer
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
  describe "GET announcers feeds" do
    it "returns http success" do
      get :announcers_feed
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
