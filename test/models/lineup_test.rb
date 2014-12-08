# == Schema Information
#
# Table name: lineups
#
#  id         :integer          not null, primary key
#  jam_id     :integer
#  roster_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require "test_helper"

describe Lineup do
  let(:lineup) { Lineup.new }

  it "must be valid" do
    lineup.must_be :valid?
  end
end
