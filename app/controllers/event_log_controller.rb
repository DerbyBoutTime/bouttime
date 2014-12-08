class EventLogController < WebsocketRails::BaseController
  def initialize_session

  end

  def log
    logger.debug "Called log!"
  end

end