# frozen_string_literal: true

require 'prologix_gpib_usb/version'

module PrologixGpibUsb
  require 'rubyserial'
  class Error < StandardError; end

  def open_connection
    times_tried = 0
    max_tries = 9
    controller_found = false

    until controller_found
      begin
        serial_port = Serial.new("/dev/ttyUSB#{count}")
        serial_port.write("++ver\r\n")
        puts 'Made connection' if serial_port.gets.include? 'Prologix'
      rescue Errno::ENOENT
        break if (times_tried += 1) >= max_tries

        puts 'File not found.'
      rescue Errno::EACCES
        puts 'Insufficient permissions, not allowed to open file.'
      end
    end
  end

  def reset
    serial_port = Serial.new('/dev/ttyUSB0')
  end
end
