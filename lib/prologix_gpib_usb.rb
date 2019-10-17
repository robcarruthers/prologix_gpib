# frozen_string_literal: true

require 'prologix_gpib_usb/version'

module PrologixGpibUsb
  require 'rubyserial'
  class Error < StandardError; end

  def open_connection
    path_str, dir = if RubySerial::ON_LINUX
                      ['tty.USB', '/dev/']
                    elsif RubySerial::ON_WINDOWS
                      ['TODO: Implement find device for Windows', 'You lazy bugger']
                    else
                      ['tty.usbserial', '/dev/']
                    end
    directory = Dir.new dir
    paths = directory.each_child.select { |name| name.include?(path_str) }
    paths.each do |path|
      @serial_port = Serial.new(directory.path + path)
      @serial_port.write("++ver\r\n")
      return true if @serial_port.gets.include? 'Prologix'

      @serial_port.close
    end
    raise Error, 'ConnectionError: No Prologix devices found.'
  end

  def close_connection
    return unless connected?

    @serial_port.close
    @serial_port = nil?
  end

  def write(_str)
    return unless connected?

    @serial_port.write(_str)
  end

  def read(_bytes)
    return unless connected?

    @serial_port.read(_bytes)
  end

  def readline
    return unless connected?

    @serial_port.gets.chomp
  end

  def version
    return unless connected?

    @serial_port.write("++ver\r\n")
    readline
  end

  def address=(addr)
    return unless connected?

    @serial_port.write("++addr #{addr}\r\n")
  end

  def address
    return unless connected?

    @serial_port.write("++addr\r\n")
    @serial_port.gets.chomp
  end

  private

  def connected?
    if @serial_port.nil?
      raise Error, 'ConnectionError: No open Prologix device connections.'
    end

    true
  end
end

class Gpib
  include PrologixGpibUsb
end
