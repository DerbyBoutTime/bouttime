# == Schema Information
#
# Table name: skater_states
#
#  id            :integer          not null, primary key
#  team_state_id :integer
#  skater_id     :integer
#
class SkaterState < ActiveRecord::Base
	belongs_to :team_state
	belongs_to :skater
	has_many :penalty_states, -> { order('sort ASC') }
end
