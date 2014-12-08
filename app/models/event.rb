# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  data       :json
#  game_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Event < ActiveRecord::Base
  belongs_to :game
end
