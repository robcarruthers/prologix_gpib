module PrologixGpib::Lan
  class Error < StandardError
  end

  DEVICE_PORT = 1234
  EOL = "\r\n".freeze

  def initialize(ip, mode: :controller, address: 9)
    @ip_address = ip

    # open_serial_port(paths)
    # flush
    # self.mode = mode
    # self.address = address
    # self.auto = :disable
    # self.eos = 0

    yield self if block_given?
  end

  def version
    socket = TCPSocket.new @ip_address, DEVICE_PORT
    socket.send "++ver#{EOL}", 0
    sleep 0.1
    str = socket.gets.chomp
    socket.close
    str
  end
end
