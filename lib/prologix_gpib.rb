# frozen_string_literal: true

require 'rubyserial'
require 'prologix_gpib/version'
require 'prologix_gpib/lan'
require 'prologix_gpib/usb'
require 'prologix_gpib/cli'

module PrologixGpib
  class UsbController
    include PrologixGpib::Usb
    include PrologixGpib::Usb::Commands
  end

  class LanController
    include PrologixGpib::Lan
  end

  # Ideally this class needs to handle finding all avaliable Prologix GPIB controllers (USB and Ethernet),
  # But for now it simply passes the Prologix USB device paths onto the controller class
  # No windows serial support just yet.
  class << self
    def new
      self
    end

    # Find first avaliable Prologix controller and return a valid controller object
    def open

    end

    def controller_paths
      usb_paths
    end

    private

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
end