module PrologixGpib::Usb
  require 'timeout'

  class Error < StandardError
  end

  EOL = "\r\n".freeze

  attr_reader :serial_port

  def initialize(path, mode: :controller, address: 9)
    paths = path.nil? ? PrologixGpib.controller_paths : [path]
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

    t = Timeout.timeout(1, Timeout::Error, 'No response from Data Acquisistion') { getline }
  end

  def sr(register = nil)
    write 'SR'
    write '++read eoi'
    array = []
    24.times { array << readline }
    array.map! { |byte| '%08b' % byte.to_i }
    register.nil? ? array : array[register - 1]
  end

  private

  def open_serial_port(paths)
    paths.each do |path|
      @serial_port = Serial.new(path)
      write('++ver')
      return if getline.include? 'Prologix'
    end
    raise Error, 'No Prologix USB controllers found.'
  end

  def connected?
    raise Error, 'ConnectionError: No open Prologix device connections.' if @serial_port.nil?

    true
  end

  # This method will block until the EOL terminator is received
  # The lower level gets method is pure ruby, so can be safely used with Timeout.
  def getline
    return unless connected?

    @serial_port.gets(EOL).chomp
  end
end
