class EventsController < WebsocketRails::BaseController

  def initialize_session
    # initialize_session method will be called the first time a controller is subscribed to an event in the event router
    # perform application setup here
  end

  def generic
  end
end
