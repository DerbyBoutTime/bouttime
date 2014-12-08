require "test_helper"

describe Skater do
  let(:skater) { Skater.new }

  it "must be valid" do
    skater.must_be :valid?
  end
end
