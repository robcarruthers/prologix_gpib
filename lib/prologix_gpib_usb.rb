# frozen_string_literal: true

require 'prologix_gpib_usb/version'

module PrologixGpibUsb
  require 'rubyserial'
  class Error < StandardError; end
  attr_accessor :address

  def open_connection
    if RubySerial::ON_LINUX
      @serial_port = Serial.new('/dev/tty.USB0')
    elsif RubySerial::ON_WINDOWS
      puts 'TODO: Implement find device for Windows'
    else
      @serial_port = Serial.new('/dev/tty.usbserial-PX9HPBMB')
    end
    @serial_port.write("++ver\r\n")
    puts 'Connection made successfully.' if @serial_port.gets.include? 'Prologix'
  rescue StandardError => e
    puts e.message
    puts e.backtrace.inspect
  end

  def reset
    @serial_port.write("++clr\r\n") unless not_connected?
  end

  def version
    @serial_port.write("++ver\r\n")
    @serial_port.gets
  end

  def address=(addr)
    @serial_port.write("++addr #{addr}\r\n") unless not_connected?
  end

  def address
    not_connected? ? return : @serial_port.write("++addr\r\n")

    puts @serial_port.gets
  end
end

private
def not_connected?
  !@serial_port.closed?
end

class GpibController
  include PrologixGpibUsb
end
