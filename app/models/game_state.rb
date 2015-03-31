# == Schema Information
#
# Table name: game_states
#
#  id              :integer          not null, primary key
#  state           :integer
#  jam_number      :integer
#  period_number   :integer
#  home_id         :integer
#  away_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  jam_clock_id    :integer
#  period_clock_id :integer
#  timeout         :integer
#
class GameState < ActiveRecord::Base
  belongs_to :game
  belongs_to :home, class_name: "TeamState"
  belongs_to :away, class_name: "TeamState"
  belongs_to :jam_clock, class_name: "ClockState"
  belongs_to :period_clock, class_name: "ClockState"
  accepts_nested_attributes_for :home, :away, :period_clock, :jam_clock
  alias_method :home_attributes, :home
  alias_method :away_attributes, :away
  alias_method :period_clock_attributes, :period_clock
  alias_method :jam_clock_attributes, :jam_clock
  #enum tab: %i[jam_timer lineup_tracker scorekeeper penalty_tracker penalty_box_timer game_notes scoreboard penalty_whiteboard announcers]
  enum state: %i[pregame halftime jam lineup timeout unofficial_final final]
  enum timeout: %i[official_timeout home_team_timeout home_team_official_review away_team_timeout away_team_official_review]
  def self.demo!
    o = self.demo
    o.save
    o
  end
  def self.demo
    self.new ({
      state: :pregame,
      jam_number: 0,
      period_number: 0,
      jam_clock_attributes: {
        time: 90*60*1000,
        display: "90:00"
      },
      period_clock_attributes: {
        time: 0,
        display: "0"
      },
      home: TeamState.demo_home,
      away: TeamState.demo_away
    })
  end
  def jam_clock_label
    state.to_s.humanize.upcase
  end
  def penalties
    Penalty.demo.map{|p| p.as_json}
  end
  def except_time_stamps
    { except: [:created_at, :updated_at] }
  end
  def team_state_json_options
    {
      include: {
        jammer_attributes: except_time_stamps,
        skaters: except_time_stamps,
        skater_states: { include: {
          skater: except_time_stamps,
          penalty_states: { include: {
            penalty: except_time_stamps
          }}.merge(except_time_stamps)
        }}.merge(except_time_stamps),
        jam_states: {include: {
          pass_states: except_time_stamps,
          lineup_statuses: except_time_stamps,
          pivot: except_time_stamps,
          blocker1: except_time_stamps,
          blocker2: except_time_stamps,
          blocker3: except_time_stamps,
          jammer: except_time_stamps,
          jammer_box_state: { include: {
            skater: except_time_stamps,
            clock_state: except_time_stamps
          }}.merge(except_time_stamps),
          blocker1_box_state: { include: {
            skater: except_time_stamps,
            clock_state: except_time_stamps
          }}.merge(except_time_stamps),
          blocker2_box_state: { include: {
            skater: except_time_stamps,
            clock_state: except_time_stamps
          }}.merge(except_time_stamps)
        }}.merge(except_time_stamps),
      }
    }.merge(except_time_stamps)
  end
  def as_json
    super(
      include: {
        :home_attributes => team_state_json_options,
        :away_attributes => team_state_json_options,
        :jam_clock_attributes => except_time_stamps,
        :period_clock_attributes => except_time_stamps,
        :game => {}
      },
      methods: :penalties
    )
  end
  def to_json(options = {})
    hash = self.as_json
    JSON.pretty_generate(hash, options)
  end
  def find_or_initialize_pass_state_by(attrs)
    team = attrs["team"]
    jam_number = attrs["jamNumber"]
    pass_number = attrs["passNumber"]
    self.send(team).
      jam_states.
      find_by(jam_number: jam_number).
      pass_states.find_or_initialize_by(pass_number: pass_number)
  end
  private
  def init_teams
    self.build_home if self.home.nil?
    self.build_away if self.away.nil?
  end
end
