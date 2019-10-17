# frozen_string_literal: true

require 'prologix_gpib_usb/version'

module PrologixGpibUsb
  require 'rubyserial'
  class Error < StandardError; end

  EOL = "\r\n"

  def open_connection
    path_str, dir = if RubySerial::ON_LINUX
                      ['ttyUSB', '/dev/']
                    elsif RubySerial::ON_WINDOWS
                      ['TODO: Implement find device for Windows', 'You lazy bugger']
                    else
                      ['tty.usbserial', '/dev/']
                    end
    directory = Dir.new dir
    paths = directory.each_child.select { |name| name.include?(path_str) }
    paths.each do |path|
      @serial_port = Serial.new(directory.path + path)
      write('++ver')
      next unless readline.include? 'Prologix'

      set_auto_read_after_write :disable
      set_operation_mode :controller
      return true
    end
    raise Error, 'ConnectionError: No Prologix devices found.'
  end

  def close_connection
    return unless connected?

    @serial_port.close
    @serial_port = nil
    @serial_port.nil?
  end

  def write(str)
    return unless connected?

    @serial_port.write("#{str}#{EOL}")
  end

  def read(bytes)
    return unless connected?

    @serial_port.read(bytes)
  end

  def readline
    return unless connected?

    @serial_port.gets.chomp
  end

  def set_read_timeout(milliseconds)
    return unless connected? || milliseconds.class != Integer

    write("++read_tmo_ms #{milliseconds}")
  end

  def set_mode(op_mode)
    case op_mode
    when 0, 1
      write("++mode #{op_mode}")
    when :controller
      set_mode(1)
    when :device
      set_mode(0)
    end
  end
  alias set_operation_mode set_mode

  def mode
    write('++mode')
    readline
  end
  alias operation_mode mode

  def set_auto(auto_mode)
    case auto_mode
    when 0, 1
      write("++auto #{auto_mode}")
    when :talk, :enable
      set_auto(1)
    when :listen, :disable
      set_auto(0)
    end
  end
  alias set_auto_read_after_write set_auto

  def auto
    write('++auto')
    readline
  end
  alias auto_read_after_write auto

  def version
    write('++ver')
    readline
  end

  def set_addr(addr)
    write("++addr #{addr}")
  end
  alias set_address set_addr

  def addr
    write('++addr')
    readline
  end
  alias address addr

  def trigger(addr_list = [addr])
    write("++trg #{addr_list.join(' ')}")
  end

  def clr
    write('++clr')
  end

  def reset
    write('++rst')
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
