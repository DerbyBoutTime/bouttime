# == Schema Information
#
# Table name: pass_states
#
#  id            :integer          not null, primary key
#  pass_number   :integer
#  skater_number :string(255)
#  points        :integer
#  injury        :boolean
#  lead          :boolean
#  lost_lead     :boolean
#  calloff       :boolean
#  nopass        :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  jam_state_id  :integer
#

class PassState < ActiveRecord::Base
  belongs_to :jam_state
end
