require 'timeout'

module PrologixGpib::Lan
  class Error < StandardError
  end

  DEVICE_PORT = 1234
  EOL = "\r\n".freeze

  def initialize(ip, mode: :controller, address: 9)
    open_socket(ip)

    # open_serial_port(paths)
    # flush
    # self.mode = mode
    # self.address = address
    # self.auto = :disable
    # self.eos = 0

    yield self if block_given?
  end

  def write(command)
    return unless connected?

    @socket.send "#{command}#{EOL}", 0
    sleep 0.1
  end

  def read
    return unless connected?

    @socket.gets.chomp
  end

  private

  def open_socket(ip)
    @socket = TCPSocket.new ip, DEVICE_PORT
    write('++ver')
    return if getline.include? 'Prologix'

    raise Error, 'No Prologix LAN controllers found.'
  end

  def connected?
    raise Error, 'ConnectionError: No open Prologix device connections.' if @socket.nil?

    true
  end

  def readline
    return unless connected?

    t = Timeout.timeout(1, Timeout::Error, "No response from device at #{@socket.peeraddr[3]}") { getline }
  end

  # This method will block until the EOL terminator is received
  # The lower level gets method is pure ruby, so can be safely used with Timeout.
  def getline
    return unless connected?

    @socket.gets(EOL).chomp
  end

  def device_query(command)
    write(command)
    readline
  end
end
