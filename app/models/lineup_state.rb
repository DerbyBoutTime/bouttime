# == Schema Information
#
# Table name: lineup_states
#
#  id            :integer          not null, primary key
#  jam_number    :integer
#  jam_ended     :boolean
#  game_state_id :integer
#  home_state_id :integer
#  away_state_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class LineupState < ActiveRecord::Base
  belongs_to :game_state
  belongs_to :home_state, class_name: 'LineupTeamState'
  belongs_to :away_state, class_name: 'LineupTeamState'

  accepts_nested_attributes_for :home_state, :away_state
  alias_method :home_state_attributes, :home_state
  alias_method :away_state_attributes, :away_state

  def init_teams
  	self.build_home_state if self.home_state.nil?
  	self.build_away_state if self.away_state.nil?
  end

  after_initialize :init_teams
end
