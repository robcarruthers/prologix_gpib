# This is a 'simplified' port of the Net Finder Linux util python script
module PrologixGpib::Lan::Utils
  require 'socket'
  require 'ipaddr'

  NETFINDER_SERVER_PORT = 3040

  NF_IDENTIFY = 0
  NF_IDENTIFY_REPLY = 1
  NF_ASSIGNMENT = 2
  NF_ASSIGNMENT_REPLY = 3
  NF_FLASH_ERASE = 4
  NF_FLASH_ERASE_REPLY = 5
  NF_BLOCK_SIZE = 6
  NF_BLOCK_SIZE_REPLY = 7
  NF_BLOCK_WRITE = 8
  NF_BLOCK_WRITE_REPLY = 9
  NF_VERIFY = 10
  NF_VERIFY_REPLY = 11
  NF_REBOOT = 12
  NF_SET_ETHERNET_ADDRESS = 13
  NF_SET_ETHERNET_ADDRESS_REPLY = 14
  NF_TEST = 15
  NF_TEST_REPLY = 16

  NF_SUCCESS = 0
  NF_CRC_MISMATCH = 1
  NF_INVALID_MEMORY_TYPE = 2
  NF_INVALID_SIZE = 3
  NF_INVALID_IP_TYPE = 4

  NF_MAGIC = 0x5A

  NF_IP_DYNAMIC = 0
  NF_IP_STATIC = 1

  NF_ALERT_OK = 0x00
  NF_ALERT_WARN = 0x01
  NF_ALERT_ERROR = 0xFF

  NF_MODE_BOOTLOADER = 0
  NF_MODE_APPLICATION = 1

  NF_MEMORY_FLASH = 0
  NF_MEMORY_EEPROM = 1

  NF_REBOOT_CALL_BOOTLOADER = 0
  NF_REBOOT_RESET = 1

  HEADER_FMT = 'CCna8'.freeze
  IDENTIFY_REPLY_FMT = '!H6c4s4s4s4s4s4s32s'.freeze
  ASSIGNMENT_FMT = '!3xc4s4s4s32x'.freeze
  ASSIGNMENT_REPLY_FMT = '!c3x'.freeze
  FLASH_ERASE_FMT = HEADER_FMT
  FLASH_ERASE_REPLY_FMT = HEADER_FMT
  BLOCK_SIZE_FMT = HEADER_FMT
  BLOCK_SIZE_REPLY_FMT = '!H2x'.freeze
  BLOCK_WRITE_FMT = '!cxHI'.freeze
  BLOCK_WRITE_REPLY_FMT = '!c3x'.freeze
  VERIFY_FMT = HEADER_FMT
  VERIFY_REPLY_FMT = '!c3x'.freeze
  REBOOT_FMT = '!c3x'.freeze
  SET_ETHERNET_ADDRESS_FMT = '!6s2x'.freeze
  SET_ETHERNET_ADDRESS_REPLY_FMT = HEADER_FMT
  TEST_FMT = HEADER_FMT
  TEST_REPLY_FMT = '!32s'.freeze

  MAX_ATTEMPTS = 10
  MAX_TIMEOUT = 0.5

  BRADCAST_ADDRESS = '255.255.255.255'

  private

  def devices
    seq = rand(0..65_535)
    sock = UDPSocket.new
    sock.setsockopt(:SOL_SOCKET, :SO_BROADCAST, true)

    data = [NF_MAGIC, NF_IDENTIFY, seq, "\xFF\xFF\xFF\xFF\xFF\xFF"].pack(HEADER_FMT)
    sock.send(data, 0, BRADCAST_ADDRESS, NETFINDER_SERVER_PORT)

    while true
      data, addr = sock.recvfrom(256)
      p "From addr: #{addr}, msg: #{data}"
      # p r_data.unpack('CCna8')
      # puts ''
    end

    sock.close
  end
end
