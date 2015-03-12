# == Schema Information
#
# Table name: skaters
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  number     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require "test_helper"

describe Skater do
  let(:skater) { Skater.new }

  it "must be valid" do
    skater.must_be :valid?
  end
end
