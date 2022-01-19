module PrologixGpib::Lan::Commands
  private

  def devices
    broadcast
  end

  def broadcast
    addr = '255.255.255.255'
    sock = UDPSocket.new
    sock.setsockopt(:SOL_SOCKET, :SO_BROADCAST, true)

    port = 3040

    data = [90, 0, 11_111, "\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00"].pack('CCna8')
    sock.send(data, 0, addr, port)

    while true
      r_data, r_addr = sock.recvfrom(2000) # if this number is too low it will drop the larger packets and never give them to you
      p "From addr: #{r_addr}, msg: #{r_data}"
      # p r_data.unpack('CCna8')
      # puts ''
    end

    sock.close
  end
end
