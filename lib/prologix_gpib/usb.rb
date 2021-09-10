module PrologixGpib::Usb
  require 'rubyserial'

  class Error < StandardError; end

  EOL = "\r\n"

  attr_reader :serial_port

  def initialize(path = nil, mode: :controller, address: 9)
    paths = path.nil? ? device_paths : [path]
    open_serial_port(paths)
    flush
    self.mode = mode
    self.address = address
    self.auto = :disable
    self.eos = 0

    yield self if block_given?
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

  private

  def device_paths
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

  def open_serial_port(paths)
    paths.each do |path|
      @serial_port = Serial.new(path)
      write('++ver')
      return if readline.include? 'Prologix'
    end
    raise Error, 'No Prologix USB controllers found.'
  end

  def connected?
    raise Error, 'ConnectionError: No open Prologix device connections.' if @serial_port.nil?

    true
  end
end
