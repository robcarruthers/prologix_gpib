module PrologixGpib::Discovery
  require 'socket'
  require 'ipaddr'
  require 'bindata'
  require 'timeout'

  class Error < StandardError
  end

  def avaliable_controllers
    { usb: usb_device_paths, lan: lan_device_ips }
  end

  class IPAddr < BinData::Primitive
    array :octets, type: :uint8, initial_length: 4

    def set(val)
      self.octets = val.split(/\./).map(&:to_i)
    end

    def get
      self.octets.map(&:to_s).join('.')
    end
  end

  class MacAddr < BinData::Primitive
    array :octets, type: :uint8, initial_length: 6

    def set(val)
      self.octets = val.split(/:/).map(&:hex)
    end

    def get
      self.octets.map { |octet| '%02x' % octet }.join(':')
    end
  end

  class NFHeader < BinData::Record
    endian :big
    uint8 :magic
    uint8 :identify
    uint16 :seq
    mac_addr :eth_addr
    bit16 :reserved, initial_value: 0x0000
  end

  class NFIdentifyReply < BinData::Record
    endian :big
    nf_header :header
    uint16 :uptime_days
    uint8 :uptime_hrs
    uint8 :uptime_mins
    uint8 :uptime_secs
    uint8 :mode
    uint8 :alert
    uint8 :ip_type
    ip_addr :addr
    ip_addr :netmask
    string :ip_gw, read_length: 4
    string :app_ver, read_length: 4
    string :boot_ver, read_length: 4
    string :hw_ver, read_length: 4
  end

  NF_MAGIC = 0x5a
  HEADER_FMT = 'CCna8'
  NF_IDENTIFY = 0
  NF_IDENTIFY_REPLY = 1
  BROADCAST_PORT = 3040
  BROADCAST_ADDRESS = '255.255.255.255'
  TIMEOUT = 0.5

  private

  def lan_device_ips
    seq = rand(0..65_535)

    # puts "Seq = #{seq}"
    sock = UDPSocket.new
    sock.setsockopt(:SOL_SOCKET, :SO_BROADCAST, true)

    # data = [NF_MAGIC, NF_IDENTIFY, seq, "\xFF\xFF\xFF\xFF\xFF\xFF"].pack(HEADER_FMT)

    data = NFHeader.new
    data.magic = NF_MAGIC
    data.identify = NF_IDENTIFY
    data.seq = seq
    data.eth_addr = 'FF:FF:FF:FF:FF:FF'

    sock.send(data.to_binary_s, 0, BROADCAST_ADDRESS, BROADCAST_PORT)
    array = []
    replies = []
    begin
      Timeout.timeout(TIMEOUT) do
        while true
          data, addr = sock.recvfrom(1000)
          replies << data
        end
      end
    rescue Timeout::Error
      replies.each do |data|
        begin
          reply = NFIdentifyReply.read(data)
        rescue EOFError
          # About 1% of responses are not always as expected from the controller
          next
        end
        next if array.include?(reply.addr)
        array << reply.addr if reply.header.seq == seq && reply.header.identify == NF_IDENTIFY_REPLY
      end
      sock.close
      array
    end
  end

  def usb_device_paths
    path_str, dir =
      if RubySerial::ON_LINUX
        %w[ttyUSB /dev/]
      elsif RubySerial::ON_WINDOWS
        ['TODO: Implement find device for Windows', 'You lazy bugger']
      else
        %w[tty.usbserial /dev/]
      end

    Dir.glob("#{dir}#{path_str}*")
  end
end
