# == Schema Information
#
# Table name: roster_skaters
#
#  id         :integer          not null, primary key
#  roster_id  :integer
#  skater_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require "test_helper"

describe RosterSkater do
  let(:roster_skater) { RosterSkater.new }

  it "must be valid" do
    roster_skater.must_be :valid?
  end
end
