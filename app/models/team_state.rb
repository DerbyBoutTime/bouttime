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
  has_many :jam_states, -> { order('jam_number ASC') }
  has_many :pass_states, through: :jam_states
  has_many :skater_states
  has_and_belongs_to_many :skaters, join_table: 'skater_states'
  accepts_nested_attributes_for :jammer, :pass_states
  accepts_nested_attributes_for :jam_states, reject_if: :reject_jam_states
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
        Skater.find_or_create_by({
          name: "Wild Cherri",
          number: "6"
        }),
        Skater.find_or_create_by({
          name: "Rebel Yellow",
          number: "12AM"
        }),
        Skater.find_or_create_by({
          name: "Agent Maulder",
          number: "X13",
        }),
        Skater.find_or_create_by({
          name: "Alassin Sane",
          number: "1973"
        }),
        Skater.find_or_create_by({
          name: "Amelia Scareheart",
          number: "B52"
        }),
        Skater.find_or_create_by({
          name: "Belle of the Brawl",
          number: "32"
        }),
        Skater.find_or_create_by({
          name: "Bruze Orman",
          number: "850"
        }),
        Skater.find_or_create_by({
          name: "ChokeCherry",
          number: "86"
        }),
        Skater.find_or_create_by({
          name: "Hollicidal",
          number: "1013"
        }),
        Skater.find_or_create_by({
          name: "Jammunition",
          number: "50CAL"
        }),
        Skater.find_or_create_by({
          name: "Jean-Juke Picard",
          number: "1701"
        }),
        Skater.find_or_create_by({
          name: "Madditude Adjustment",
          number: "23"
        }),
        Skater.find_or_create_by({
          name: "Nattie Long Legs",
          number: "504"
        }),
        Skater.find_or_create_by({
          name: "Ozzie Kamakazi",
          number: "747"
        })
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
        Skater.find_or_create_by({
          name: "Ana Bollocks",
          number: "00"
        }),
        Skater.find_or_create_by({
          name: "Bonita Apple Bomb",
          number: "4500º"
        }),
        Skater.find_or_create_by({
          name: "Bonnie Thunders",
          number: "340"
        }),
        Skater.find_or_create_by({
          name: "Caf Fiend",
          number: "314"
        }),
        Skater.find_or_create_by({
          name: "Claire D. Way",
          number: "1984"
        }),
        Skater.find_or_create_by({
          name: "Davey Blockit",
          number: "929"
        }),
        Skater.find_or_create_by({
          name: "Donna Matrix",
          number: "2"
        }),
        Skater.find_or_create_by({
          name: "Fast and Luce",
          number: "17"
        }),
        Skater.find_or_create_by({
          name: "Fisti Cuffs",
          number: "241"
        }),
        Skater.find_or_create_by({
          name: "Hyper Lynx",
          number: "404"
        }),
        Skater.find_or_create_by({
          name: "Mick Swagger",
          number: "53"
        }),
        Skater.find_or_create_by({
          name: "Miss Tea Maven",
          number: "1706"
        }),
        Skater.find_or_create_by({
          name: "OMG WTF",
          number: "753"
        }),
        Skater.find_or_create_by({
          name: "Puss 'n Glutes",
          number: "999 Lives"
        })
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
  def update_points
    self.update_column :points, (self.pass_states.pluck :points).compact.sum
  end
  private
  def reject_jam_states(attributes)
    self.jam_states.any? {|jam| jam.jam_number == attributes[:jam_number]}
  end
  def init_jammer
    self.build_jammer if self.jammer.nil?
  end
  def init_jams
    self.jam_states.build(jam_number: 1) if self.jam_states.empty?
  end
  after_initialize :init_jammer, :init_jams
end
