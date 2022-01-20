#!/usr/bin/env ruby
require 'bindata'

class NFHeader < BinData::Record
  endian :big
  uint8 :magic
  uint8 :identify
  uint16 :seq
  string :addr, read_length: 6
  string :res, read_length: 2
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

@identify = "Z\x00+g\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00"
@indentify_reply =
  'Z\x01+g\x00!i\x01\x00\xd7\x00\x00\x00\x00\x02\x03$\x01\x00\x00\xc0\xa8\n\xa1\xff\xff\xff\x00\xc0\xa8\n\x01\x01\x03\x00\x00\x01\x01\x00\x00\x01\x01\x00\x00\xa5\xbb\xa5{\xf6E\x12+\xa7w=\x19z\xa7\x964H\xeb\x8c\x93*\x85Rz$\xb3\x96`\x96\xca\xa2\xef'
