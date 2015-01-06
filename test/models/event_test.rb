# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  data       :json
#  created_at :datetime
#  updated_at :datetime
#  name       :string(255)
#  role       :string(255)
#

require "test_helper"

describe Event do
  let(:event) { Event.new }

  it "must be valid" do
    event.must_be :valid?
  end
end
