# == Schema Information
#
# Table name: team_states
#
#  id                        :integer          not null, primary key
#  name                      :string(255)
#  initials                  :string(255)
#  color_bar_style           :text
#  points                    :integer
#  is_taking_official_review :boolean
#  is_taking_timeout         :boolean
#  timeouts                  :integer
#  jammer_id                 :integer
#  created_at                :datetime
#  updated_at                :datetime
#  color                     :string(255)
#  official_reviews_retained :integer          default(0)
#  logo                      :text
#  jam_points                :integer
#  has_official_review       :boolean
#  text_color                :string(255)
#  is_selected               :boolean          default(FALSE)
#

class TeamState < ActiveRecord::Base
  belongs_to :jammer, class_name: "JammerState"
  has_one :game_state
  has_many :jam_states
  has_many :pass_states, through: :jam_states
  has_and_belongs_to_many :skaters, join_table: 'rosters'

  accepts_nested_attributes_for :jammer, :pass_states, :jam_states
  alias_method :jammer_attributes, :jammer

  def self.demo_home
    self.new({
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
      timeouts: 3,
      jammer_attributes: {
        is_lead: false,
        name: "Nattie Long Legs",
        number: "504"
      },
      skaters: [
        Skater.find_by(name: "Wild Cherri"),
        Skater.find_by(name: "Rebel Yellow"),
        Skater.find_by(name: "Agent Maulder"),
        Skater.find_by(name: "Alassin Sane"),
        Skater.find_by(name: "Amelia Scareheart"),
        Skater.find_by(name: "Belle of the Brawl"),
        Skater.find_by(name: "Bruze Orman"),
        Skater.find_by(name: "ChokeCherry"),
        Skater.find_by(name: "Hollicidal"),
        Skater.find_by(name: "Jammunition"),
        Skater.find_by(name: "Jean-Juke Picard"),
        Skater.find_by(name: "Madditude Adjustment"),
        Skater.find_by(name: "Nattie Long Legs"),
        Skater.find_by(name: "Ozzie Kamakazi")
      ]
    })
  end

  def self.demo_away
    self.new({
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
      timeouts: 3,
      jammer_attributes: {
        is_lead: true,
        name: "Bonnie Thunders",
        number: "340"
      },
      skaters: [
        Skater.find_by(name: "Ana Bollocks"),
        Skater.find_by(name: "Bonita Apple Bomb"),
        Skater.find_by(name: "Bonnie Thunders"),
        Skater.find_by(name: "Caf Fiend"),
        Skater.find_by(name: "Claire D. Way"),
        Skater.find_by(name: "Davey Blockit"),
        Skater.find_by(name: "Donna Matrix"),
        Skater.find_by(name: "Fast and Luce"),
        Skater.find_by(name: "Fisti Cuffs"),
        Skater.find_by(name: "Hyper Lynx"),
        Skater.find_by(name: "Mick Swagger"),
        Skater.find_by(name: "Miss Tea Maven"),
        Skater.find_by(name: "OMG WTF"),
        Skater.find_by(name: "Puss 'n Glutes")
      ]
    })
  end

  def as_json
    super(include: [:jammer_attributes, :jam_states, :pass_states, :skaters], methods: [:color_bar_style])
  end

  def to_json(options = {})
     JSON.pretty_generate(self.as_json, options)
  end

  def color_bar_style
    {
      color: self.text_color,
      backgroundColor: self.color
    }
  end

  private

  def init_jammer
    self.build_jammer if self.jammer.nil?
  end
  after_initialize :init_jammer
end
