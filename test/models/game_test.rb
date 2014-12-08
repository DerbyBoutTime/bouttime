# == Schema Information
#
# Table name: games
#
#  id                                 :integer          not null, primary key
#  end_time                           :datetime
#  start_time                         :datetime
#  venue_id                           :integer
#  created_at                         :datetime
#  updated_at                         :datetime
#  interleague_game_reporting_form_id :integer
#

require "test_helper"

describe Game do
  let(:game) { Game.new }

  it "must be valid" do
    game.must_be :valid?
  end
end
