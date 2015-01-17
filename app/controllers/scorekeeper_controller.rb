class ScorekeeperController < WebsocketController
  def initialize
  end

  def set_jammer
    puts event.name, message
  end
end
