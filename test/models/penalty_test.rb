# == Schema Information
#
# Table name: penalties
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  code       :string(255)
#  sort       :integer
#  created_at :datetime
#  updated_at :datetime
#

require "test_helper"

describe Penalty do
  let(:penalty) { Penalty.new }

  it "must be valid" do
    penalty.must_be :valid?
  end
end
