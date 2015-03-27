# == Schema Information
#
# Table name: jammer_states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  number     :string(255)
#  is_lead    :boolean
#  created_at :datetime
#  updated_at :datetime
#
class JammerState < ActiveRecord::Base
end
