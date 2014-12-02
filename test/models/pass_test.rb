require "test_helper"

describe Pass do
  let(:pass) { Pass.new }

  it "must be valid" do
    pass.must_be :valid?
  end
end
