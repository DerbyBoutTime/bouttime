# == Schema Information
#
# Table name: officials
#
#  id            :integer          not null, primary key
#  certification :string(255)
#  league        :string(255)
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

require "test_helper"

describe Official do
  let(:official) { Official.new }

  it "must be valid" do
    official.must_be :valid?
  end
end
