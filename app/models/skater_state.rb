# == Schema Information
#
# Table name: skater_states
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  number        :string(255)
#  team_state_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class SkaterState < ActiveRecord::Base
  belongs_to :team_state
end
