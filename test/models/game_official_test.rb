require "test_helper"

describe GameOfficial do
  let(:game_official) { GameOfficial.new }

  it "must be valid" do
    game_official.must_be :valid?
  end
end
