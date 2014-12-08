# == Schema Information
#
# Table name: officials
#
#  id            :integer          not null, primary key
#  certification :string(255)
#  league        :string(255)
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Official < ActiveRecord::Base
  has_many :game_officials
  has_many :games, :through => :game_officials
end
