class Penalty < ActiveRecord::Base
  belongs_to :jam
  belongs_to :skater
end
