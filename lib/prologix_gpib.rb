# frozen_string_literal: true

require 'prologix_gpib/version'
require 'prologix_gpib/lan'
require 'prologix_gpib/usb'
require 'prologix_gpib/usb/commands'

module Prologix
  class UsbController
    include PrologixGpib::Usb::Commands
    include PrologixGpib::Usb
  end

  class LanController
    include PrologixGpib::Lan
  end
end
