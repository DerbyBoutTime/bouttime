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

class Skater < ActiveRecord::Base
  has_and_belongs_to_many :team_states, join_table: 'rosters'
end
