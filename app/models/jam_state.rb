# == Schema Information
#
# Table name: jam_states
#
#  id            :integer          not null, primary key
#  team_state_id :integer
#  jam_number    :integer
#  skater_number :string(255)
#  points        :integer
#  injury        :boolean
#  lead          :boolean
#  lost_lead     :boolean
#  calloff       :boolean
#  nopass        :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  is_selected   :boolean          default(FALSE)
#

class JamState < ActiveRecord::Base
  belongs_to :team_state
  has_many :pass_states, -> { order('pass_number ASC') }
end
