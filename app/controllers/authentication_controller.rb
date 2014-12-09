class AuthenticationController < WebsocketRails::BaseController
  def initialize_session

  end

  def client_heartbeat
  end

  def client_connected
    puts "="*80
    puts "Client connected!"
    puts "="*80
  end

  def client_disconnected
    puts "="*80
    puts "Client disconnected!"
    puts "="*80
  end
end