# == Schema Information
#
# Table name: skaters
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  number     :string(255)
#  created_at :datetime
#  updated_at :datetime
#
class Skater < ActiveRecord::Base
  has_and_belongs_to_many :team_states, join_table: 'skater_states'
end
