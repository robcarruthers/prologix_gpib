require 'socket'
require 'ipaddr'

class UDPTest
  def listen
    s = UDPSocket.new

    # membership = IPAddr.new(multicast_addr).hton + IPAddr.new(bind_addr).hton
    # s.setsockopt(:IPPROTO_UDP, :IP_ADD_MEMBERSHIP, membership)

    s.bind('', 3040)
    while true
      data, addr = s.recvfrom(1024)
      puts "addr = #{addr}\r\ndata ="
      p data
    end
  end

  def start_server
    multi_addr = '225.1.1.1'
    bind_addr = '0.0.0.0'

    sock = UDPSocket.new
    membership = IPAddr.new(multi_addr).hton + IPAddr.new(bind_addr).hton
    sock.setsockopt(:IPPROTO_IP, :IP_ADD_MEMBERSHIP, membership)
    sock.bind(bind_addr, 3040)
    while true
      data, addr = sock.recvfrom(2000) # if this number is too low it will drop the larger packets and never give them to you
      p "From addr: #{addr}, msg: #{data}"
      p data.unpack('CCna8')
      puts ''
    end
    sock.close
  end
end
