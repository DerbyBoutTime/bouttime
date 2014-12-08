# == Schema Information
#
# Table name: venues
#
#  id         :integer          not null, primary key
#  city       :string(255)
#  name       :string(255)
#  state      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Venue < ActiveRecord::Base
  has_many :games
end
