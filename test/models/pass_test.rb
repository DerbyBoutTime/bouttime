# == Schema Information
#
# Table name: passes
#
#  id               :integer          not null, primary key
#  lineup_skater_id :integer
#  number           :integer
#  score            :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require "test_helper"

describe Pass do
  before do
    @pass = Pass.new
  end

  it "must be valid" do
    @pass.must_be :valid?
  end
end
