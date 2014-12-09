class Game < ActiveRecord::Base
  belongs_to :interleague_game_reporting_form
  belongs_to :venue

  has_many :jams

  has_many :game_officials
  has_many :officials, :through => :game_officials

  has_many :rosters

  def igrf
    interleague_game_reporting_form
  end
end
