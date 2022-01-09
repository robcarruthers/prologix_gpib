#!/usr/bin/env ruby
require 'prologix_gpib'
plx = PrologixGpib::UsbController.new
puts plx.config
