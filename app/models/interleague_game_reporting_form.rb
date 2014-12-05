class InterleagueGameReportingForm < ActiveRecord::Base
  mount_uploader :form, IgrfUploader

  has_one :game
end
