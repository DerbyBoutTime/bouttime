require "test_helper"

describe Jam do
  let(:jam) { Jam.new }

  it "must be valid" do
    jam.must_be :valid?
  end
end
