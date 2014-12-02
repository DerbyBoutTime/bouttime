class Jam < ActiveRecord::Base
  belongs_to :game

  has_one :lineup

  has_many :passes
  has_many :penalties
end
