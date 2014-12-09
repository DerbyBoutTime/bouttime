class EventLogController < WebsocketRails::BaseController
  def initialize_session

  end

  def log
    puts "#{event.name}"
    puts message
    Event.create name: event.name, data: message, role: message["role"]
  end

end