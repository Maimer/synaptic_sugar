require 'celluloid/io'

class Server
  include Celluloid::IO
  finalizer :shutdown

  def initialize(host, port)
    puts "Starting Synaptic Sugar Server at #{host}:#{port}."
    @server = TCPServer.new(host, port)
    @sprites = Hash.new # all the sprites, key is sprite uuid
    @players = Hash.new # the players in the game, key is server:port
    async.run
  end

  def shutdown
    @server.close if @server
  end

  def run
    loop { async.handle_connection @server.accept }
  end

  def handle_connection(socket)
    _, port, host = socket.peeraddr
    user = "#{host}:#{port}"
    puts "#{user} has joined the arena."

    loop do
      data = socket.readpartial(4096)
      data_array = data.split("\n")
      if data_array and !data_array.empty?
        begin
          data_array.each do |row|
            message = row.split("|")
            if message.size == 10
              case message[0] # first item in message tells us what to do, the rest is the sprite
              when 'obj'
                @players[user] = message[1..9] unless @players[user]
                @sprites[message[1]] = message[1..9]
              when 'del'
                @sprites.delete message[1]
              end
            end
            response = String.new
            @sprites.each_value do |sprite|
              (response << sprite.join("|") << "\n") if sprite
            end
            socket.write response
          end
        rescue Exception => exception
          puts exception.backtrace
        end
      end # end data
    end # end loop
  rescue EOFError => err
    player = @players[user]
    puts "#{player[3]} has left arena."
    @sprites.delete player[0]
    @players.delete user
    socket.close
  end
end

server, port = ARGV[0] || "0.0.0.0", ARGV[1] || 1234
supervisor = Server.supervise(server, port.to_i)
trap("INT") do
  supervisor.terminate
  exit
end

sleep
