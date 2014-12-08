class AuthenticationController < WebsocketRails::BaseController
  def initialize_session

  end

  def client_connected
    puts "Client connected!"
  end

  def client_disconnected
    puts "Client disconnected!"
  end
end