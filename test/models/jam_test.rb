# == Schema Information
#
# Table name: jams
#
#  id         :integer          not null, primary key
#  game_id    :integer
#  number     :integer
#  period     :integer
#  created_at :datetime
#  updated_at :datetime
#

require "test_helper"

describe Jam do
  let(:jam) { Jam.new }

  it "must be valid" do
    jam.must_be :valid?
  end
end
