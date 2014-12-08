# == Schema Information
#
# Table name: lineup_skaters
#
#  id         :integer          not null, primary key
#  lineup_id  :integer
#  skater_id  :integer
#  role       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require "test_helper"

describe LineupSkater do
  let(:lineup_skater) { LineupSkater.new }

  it "must be valid" do
    lineup_skater.must_be :valid?
  end
end
