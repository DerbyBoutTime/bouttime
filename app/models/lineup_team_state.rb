# == Schema Information
#
# Table name: lineup_team_states
#
#  id              :integer          not null, primary key
#  no_pivot        :boolean
#  star_pass       :boolean
#  pivot_number    :string(255)
#  blocker1_number :string(255)
#  blocker2_number :string(255)
#  blocker3_number :string(255)
#  jammer_number   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class LineupTeamState < ActiveRecord::Base
	has_one :lineup_state
	has_many :lineup_status_states

	accepts_nested_attributes_for :lineup_status_states
	alias_method :lineup_status_states_attributes, :lineup_status_states

	private

	def destroy_statuses
		self.lineup_status_states.destroy_all
	end

	before_update :destroy_statuses
end
