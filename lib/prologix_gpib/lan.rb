module PrologixGpib::Lan
  class Error < StandardError
  end

  DEVICE_PORT = 1234
  EOL = "\r\n"

  def initialize(ip, mode: :controller, address: 9)
    @socket = TCPSocket.new ip, DEVICE_PORT

    # open_serial_port(paths)
    # flush
    # self.mode = mode
    # self.address = address
    # self.auto = :disable
    # self.eos = 0

    yield self if block_given?
  end

  def version
    @socket.send "++ver#{EOL}", 0
    @socket.gets.chomp
  end
end
