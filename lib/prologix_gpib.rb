# frozen_string_literal: true

require 'rubyserial'
require 'prologix_gpib/version'
require 'prologix_gpib/lan'
require 'prologix_gpib/lan/commands'
require 'prologix_gpib/usb'
require 'prologix_gpib/usb/commands'
require 'prologix_gpib/discovery'
require 'prologix_gpib/cli'

module PrologixGpib
  class UsbController
    include PrologixGpib::Usb
    include PrologixGpib::Usb::Commands
  end

  class LanController
    include PrologixGpib::Lan
    include PrologixGpib::Lan::Commands
  end

  class Finder
    include PrologixGpib::Discovery
  end

  # No windows serial support just yet.
  class << self
    def new
      self
    end
  end
end
