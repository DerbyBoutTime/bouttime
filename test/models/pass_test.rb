require "test_helper"

describe Pass do
  before do
    @pass = Pass.new
  end

  it "must be valid" do
    @pass.must_be :valid?
  end
end
