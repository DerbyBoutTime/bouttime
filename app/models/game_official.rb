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

class GameOfficial < ActiveRecord::Base
  belongs_to :game
  belongs_to :official
end
