# == Schema Information
#
# Table name: clock_states
#
#  id         :integer          not null, primary key
#  display    :string(16)
#  time       :integer
#  offset     :integer
#  created_at :datetime
#  updated_at :datetime
#

class ClockState < ActiveRecord::Base
  has_one :game_state
  validates :display, length: {maximum: 16}
  validate :time, numericality: {only_integer: true, greater_than: -1}
  validate :offset, numericality: {only_integer: true, greater_than: -1, less_than: 1000}

  def to_s(format)
    if format == :short
      to_clock(time)
    elsif format == :long
      to_clock(time, offset)
    else
      super
    end
  end

  private

  # Take time in seconds and offset in milliseconds and formats it as a string
  def to_clock(time, offset = nil)
    time = time.floor
    offset = offset.floor
    hours = minutes = seconds = 0
    hours = time / 3600
    minutes = (time % 3600)/60
    seconds = (time % 60)
    clock = ""
    clock << "%02i:" % hours if hours > 0
    clock << "%02i:" % minutes if minutes > 0
    clock << "%02i"  % seconds
    clock << ".%03i" % offset if offset
    clock
  end
end
