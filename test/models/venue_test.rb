# == Schema Information
#
# Table name: venues
#
#  id         :integer          not null, primary key
#  city       :string(255)
#  name       :string(255)
#  state      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require "test_helper"

describe Venue do
  let(:venue) { Venue.new }

  it "must be valid" do
    venue.must_be :valid?
  end
end
