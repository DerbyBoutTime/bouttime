class GameOfficial < ActiveRecord::Base
  belongs_to :game
  belongs_to :official
end
