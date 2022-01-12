#!/usr/bin/env ruby
require 'prologix_gpib'
paths = PrologixGpib.usb_paths

device = PrologixGpib::UsbController.new(paths[0])
puts device.config
