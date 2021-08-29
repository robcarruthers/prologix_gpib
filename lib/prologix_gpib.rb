# frozen_string_literal: true

require 'prologix_gpib/version'
require 'prologix_gpib/usb'
require 'prologix_gpib/lan'

module Prologix
  class UsbController
    include PrologixGpib::Usb

    def initialize(operational_mode = :controller, device_address: 9)
      mode = operational_mode
      address = device_address
    end
  end

  class LanController
    include PrologixGpib::Lan
  end
end