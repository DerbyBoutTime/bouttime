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
#

class TeamState < ActiveRecord::Base
  belongs_to :jammer, class_name: "JammerState"

  def as_json
    super(include: [:jammer], methods: [:color_bar_style])
  end

  def to_json(options = {})
     JSON.pretty_generate(self.as_json, options)
  end

  def color_bar_style
    {backgroundColor: "#2082a6"}
  end

  private

  def init_jammer
    self.build_jammer if self.jammer.nil?
  end
  after_initialize :init_jammer
end
