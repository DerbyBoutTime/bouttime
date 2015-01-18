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

  accepts_nested_attributes_for :jammer, :pass_states, :jam_states
  alias_method :jammer_attributes, :jammer

  def as_json
    super(include: [:jammer_attributes, :jam_states, :pass_states], methods: [:color_bar_style])
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

  def init_jammer
    self.build_jammer if self.jammer.nil?
  end
  after_initialize :init_jammer
end
