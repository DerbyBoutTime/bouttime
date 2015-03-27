class EventLogController < WebsocketRails::BaseController
  def initialize_session
  end
  def client_connected
    puts "="*80
    puts "Client Connected"
    puts "="*80
  end
  def client_disconnected
    puts "="*80
    puts "Client Disconnected"
    puts "="*80
  end
  def print
    puts "#{event.name}"
    puts message
  end
  def log
    puts "#{event.name}"
    puts message
    if message
      Event.create name: event.name, data: message
    else
      Event.create name: event.name
    end
  end
end