require "test_helper"

describe Penalty do
  let(:penalty) { Penalty.new }

  it "must be valid" do
    penalty.must_be :valid?
  end
end
