# == Schema Information
#
# Table name: game_states
#
#  id              :integer          not null, primary key
#  state           :integer
#  jam_number      :integer
#  period_number   :integer
#  jam_clock_label :string(255)
#  home_id         :integer
#  away_id         :integer
#  game_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  jam_clock       :integer
#  period_clock    :integer
#

class GameState < ActiveRecord::Base
  belongs_to :home, class_name: "TeamState"
  belongs_to :away, class_name: "TeamState"
  belongs_to :game

  enum state: [:pregame, :halftime, :jam, :lineup,
   :team_timeout, :official_timeout, :official_review,
    :unofficial_final, :final]

  def init_demo!
    self.update_attributes!({
        state: :pregame,
        jam_number: 0,
        period_number: 0,
        jam_clock: 90*60*1000,
        period_clock: 0,
      })
    self.build_home
    self.home.update_attributes!({
        name: "Atlanta Rollergirls",
        initials: "ARG",
        color: "#2082a6",
        text_color: "#ffffff",
        logo: "/assets/team_logos/Atlanta.png",
        points: 0,
        jam_points: 0,
        is_taking_official_review: false,
        is_taking_timeout: false,
        has_official_review: true,
        timeouts: 3
      })
    self.home.jammer.update_attributes!({
        is_lead: false,
        name: "Nattie Long Legs",
        number: "504"
      })
    self.build_away
    self.away.update_attributes!({
        name: "Gotham Rollergirls",
        initials: "GRG",
        color: "#f50031",
        text_color: "#ffffff",
        logo: "/assets/team_logos/Gotham.png",
        points: 0,
        jam_points: 0,
        is_taking_official_review: false,
        is_taking_timeout: false,
        has_official_review: true,
        timeouts: 3
      })
    self.away.jammer.update_attributes!({
        is_lead: true,
        name: "Bonnie Thunders",
        number: "340"
      })

    # add jam_states and pass_states
    js_home = self.home.jam_states.create({
        jam_number: 1,
        skater_number: self.home.jammer.number,
        points: nil,
        injury: nil,
        lead: true,
        lost_lead: nil,
        calloff: nil,
        nopass: nil
      })
    js_home.pass_states.create({
        pass_number: 1,
        skater_number: nil,
        points: nil,
        injury: nil,
        lead: nil,
        lost_lead: nil,
        calloff: nil,
        nopass: nil
      })
    js_away = self.away.jam_states.create({
        jam_number: 1,
        skater_number: self.away.jammer.number,
        points: nil,
        injury: nil,
        lead: true,
        lost_lead: nil,
        calloff: nil,
        nopass: nil
      })
    js_away.pass_states.create({
        pass_number: 1,
        skater_number: nil,
        points: nil,
        injury: nil,
        lead: nil,
        lost_lead: nil,
        calloff: nil,
        nopass: nil
      })
    self.save
  end

  def jam_clock_label
    state.to_s.humanize.upcase
  end

  def as_json
    super(include: {
          :home => {include: [:jammer, :jam_states, :pass_states]},
          :away => {include: [:jammer, :jam_states, :pass_states]},
          :game => {}
        }, methods: [:jam_clock_label])
  end

  def to_json(options = {})
    hash = self.as_json
    hash
    JSON.pretty_generate(hash, options)
  end

  private

  def init_teams
    self.build_home if self.home.nil?
    self.build_away if self.away.nil?
  end
  after_initialize :init_teams
end
