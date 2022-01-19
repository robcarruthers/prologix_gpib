module PrologixGpib::Discovery
  class Error < StandardError
  end

  def avaliable_controllers
    { usb: usb_paths, lan: lan_ips }
  end

  private

  def lan_ips
    %w[192.168.10.161 192.168.10.165]
  end

  def usb_paths
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
end
