require 'socket'

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

# ❯ python

# WARNING: Python 2.7 is not recommended.
# This version is included in macOS for compatibility with legacy software.
# Future versions of macOS will not include Python 2.7.
# Instead, it is recommended that you transition to using 'python3' from within Terminal.

# Python 2.7.18 (default, Nov 13 2021, 06:17:34)
# [GCC Apple LLVM 13.0.0 (clang-1300.0.29.10) [+internal-os, ptrauth-isa=deployme on darwin
# Type "help", "copyright", "credits" or "license" for more information.
# >>> "Z\x00ST\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00".unpack("!2cH6s2x")
# Traceback (most recent call last):
#   File "<stdin>", line 1, in <module>
# AttributeError: 'str' object has no attribute 'unpack'
# >>> struct.unpack("!2cH6s2x", "Z\x00ST\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00")
# Traceback (most recent call last):
#   File "<stdin>", line 1, in <module>
# NameError: name 'struct' is not defined
# >>> import struct
# >>> struct.unpack("!2cH6s2x", "Z\x00ST\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00")
# ('Z', '\x00', 21332, '\xff\xff\xff\xff\xff\xff')
# >>> struct.unpack("!2cH6s2x", "Z\x00s|\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00")
# ('Z', '\x00', 29564, '\xff\xff\xff\xff\xff\xff')
# >>> struct.unpack("!2cH6s2x", 'Z\x00+g\xFF\xFF\xFF\xFF\xFF\xFF\x00\x00')
# ('Z', '\x00', 11111, '\xff\xff\xff\xff\xff\xff')
# >>>
# 5a012b670021690100d700000000020324010000c0a80aa1ffffff00c0a80a01010300000101000001010000a5bba57bf645122ba7773d197aa7963448eb8c932a85527a24b3966096caa2ef
# "\x5a\x01\x2b\x67\x00\x21\x69\x01\x00\xd7\x00\x00\x00\x00\x02\x03\x24\x01\x00\x00\xc0\xa8\x0a\xa1\xff\xff\xff\x00\xc0\xa8\x0a\x01\x01\x03\x00\x00\x01\x01\x00\x00\x01\x01\x00\x00\xa5\xbb\xa5\x7b\xf6\x45\x12\x2b\xa7\x77\x3d\x19\x7a\xa7\x96\x34\x48\xeb\x8c\x93\x2a\x85\x52\x7a\x24\xb3\x96\x60\x96\xca\xa2\xef"
