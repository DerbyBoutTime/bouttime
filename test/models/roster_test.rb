# == Schema Information
#
# Table name: rosters
#
#  id         :integer          not null, primary key
#  home       :boolean
#  game_id    :integer
#  team_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require "test_helper"

describe Roster do
  let(:roster) { Roster.new }

  it "must be valid" do
    roster.must_be :valid?
  end
end
