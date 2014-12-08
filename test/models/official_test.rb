require "test_helper"

describe Official do
  let(:official) { Official.new }

  it "must be valid" do
    official.must_be :valid?
  end
end
