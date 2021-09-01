# frozen_string_literal: true

require 'prologix_gpib/version'
require 'prologix_gpib/usb'
require 'prologix_gpib/lan'

module Prologix
  class UsbController
    include PrologixGpib::Usb
  end

  class LanController
    include PrologixGpib::Lan
  end
end
