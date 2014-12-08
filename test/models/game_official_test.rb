# == Schema Information
#
# Table name: game_officials
#
#  id          :integer          not null, primary key
#  game_id     :integer
#  official_id :integer
#  position    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require "test_helper"

describe GameOfficial do
  let(:game_official) { GameOfficial.new }

  it "must be valid" do
    game_official.must_be :valid?
  end
end
