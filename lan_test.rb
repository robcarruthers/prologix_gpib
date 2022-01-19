require 'prologix_gpib'
require 'socket'

class Scanner
  def search(range, timeout = 0.1)
    array = []
    range.each do |x|
      s = Socket.tcp("192.168.10.#{x}", 1234, connect_timeout: timeout)
      s.write("++ver\r\n")
      array << s.gets
    rescue => error
      puts error.inspect
      next
    end
    array
  end
end
