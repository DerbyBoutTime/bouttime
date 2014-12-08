# == Schema Information
#
# Table name: interleague_game_reporting_forms
#
#  id         :integer          not null, primary key
#  form       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class InterleagueGameReportingForm < ActiveRecord::Base
  mount_uploader :form, IgrfUploader

  validates :form, presence: true

  has_one :game

  def save
    super
  rescue ActiveRecord::RecordNotUnique => exception
    errors.add :form, "'#{form.file.original_filename}' already exists"
    false
  end
end
