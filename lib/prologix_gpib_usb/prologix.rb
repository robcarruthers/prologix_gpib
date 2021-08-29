module PrologixGpibUsb::Prologix
  require 'rubyserial'
  class Error < StandardError; end

  EOL = "\r\n"

  def open
    path_str, dir = if RubySerial::ON_LINUX
                      ['ttyUSB', '/dev/']
                    elsif RubySerial::ON_WINDOWS
                      ['TODO: Implement find device for Windows', 'You lazy bugger']
                    else
                      ['tty.usbserial', '/dev/']
                    end

    Dir.glob( "#{dir}#{path_str}*" ) do |path|
      @serial_port = Serial.new(path)
      write('++ver')
      next unless readline.include? 'Prologix'

      set_auto_read_after_write :disable
      set_operation_mode :controller
      return true
    end
    raise Error, 'ConnectionError: No Prologix devices found.'
  end

  def close
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

  def read_timeout=(milliseconds)
    return unless connected? || milliseconds.class != Integer

    write("++read_tmo_ms #{milliseconds}")
  end

  def mode=(op_mode)
    new_mode = case op_mode
    when :controller, 1, '1'
      1
    when :device, 0, '0'
      0
    else
      ''
    end
    write("++mode #{new_mode}")
  end
  alias set_operation_mode mode=

  def mode
    write('++mode')
    readline
  end
  alias operation_mode mode

  def auto=(auto_mode)
    case auto_mode
    when 0, 1
      write("++auto #{auto_mode}")
    when :talk, :enable
      auto = 1
    when :listen, :disable
      auto = 0
    end
  end
  alias set_auto_read_after_write auto=

  def auto
    write('++auto')
    readline
  end
  alias auto_read_after_write auto

  def version
    write('++ver')
    readline
  end

  def address=(addr)
    write("++addr #{addr}")
  end
  alias set_address address=

  def address
    write('++addr')
    readline
  end

  def status
    write('++status')
    readline
  end

  def savecfg
    write('++savecfg')
    readline
  end

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