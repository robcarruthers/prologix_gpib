# frozen_string_literal: true

require 'prologix_gpib_usb/version'
require 'prologix_gpib_usb/prologix'
class GpibUsb
  include PrologixGpibUsb::Prologix

  def initialize(operational_mode = :controller, device_address: 9)
    mode = operational_mode
  end
end
