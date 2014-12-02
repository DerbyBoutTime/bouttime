class Official < ActiveRecord::Base
  has_many :game_officials
  has_many :games, :through :game_officials
end
