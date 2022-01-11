# PrologixGpib

[![Gem Version](https://badge.fury.io/rb/prologix_gpib.svg)](https://rubygems.org/gems/prologix_gpib)

`prologix_gpib` is a ruby gem for accessing [Prologix GPIB controllers](http://prologix.biz/). It currently only works with USB controllers on MacOS.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prologix_gpib'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prologix_gpib

## USB Controller

### CLI

The gem comes with a simple cli for querying controllers:

```bash
$ plx list
+-------------------------------------------------------------------------------+
|                             Prologix Controllers                              |
+-------+-------------------------------+---------+-----------------------------+
| index | Controller                    | Version | Path                        |
+-------+-------------------------------+---------+-----------------------------+
| 0     | Prologix GPIB-USB Controller  |  6.101  | /dev/tty.usbserial-PX9HPBMB |
| 1     | Prologix GPIB-USB Controller  |  6.107  | /dev/tty.usbserial-PXEGWA9A |
+-------+-------------------------------+---------+-----------------------------+

$ plx info 0

  Prologix gpib-usb controller
	Path: /dev/tty.usbserial-PX9HPBMB
	Firmware: 6.101
	Mode: Controller
	Device Address: 9
	Auto Read: Disabled
	Read Timeout: 200
	EOI Assertion: Enabled
	EOS: Append CR+LF
	EOT: Enabled

```

### Playing in Console

I'm enamoured by this interface, I'd like a more ruby like way of finding and connecting controllers, that works with Ethernet controllers too.

```ruby
irb(main):001:0> require 'prologix_gpib'
=> true

irb(main):002:0> paths = PrologixGpib.usb_paths
=> ["/dev/tty.usbserial-PX9HPBMB", "/dev/tty.usbserial-PXEGWA9A"]

irb(main):003:0> device = PrologixGpib::UsbController.new(paths[0])
=> #<PrologixGpib::UsbController:0x00000001574c4098 @serial_port=#<Serial:0x00000001574bfef8 @config=#<RubySerial::Posix::Termios:0x00000001574bf728>, @fd=9, @open=true>>

irb(main):004:0> device.config
=>  {:device_name=>"Prologix GPIB-USB Controller", :firmware=>"6.101", :mode=>"Device", :device_address=>"9", :auto_read=>"NA", :read_timeout=>"NA", :eoi_assertion=>"Enabled", :eos=>"Append CR+LF", :eot=>"Enabled"}

irb(main):005:0> device.address
=> "9"

irb(main):006:0> device.mode = :controller
=> :controller

irb(main):007:0> device.mode
=> "0"

irb(main):008:0> device.config
=> {:device_name=>"Prologix GPIB-USB Controller", :firmware=>"6.101", :mode=>"Controller", :device_address=>"9", :auto_read=>"Disabled", :read_timeout=>"200", :eoi_assertion=>"Enabled", :eos=>"Append CR+LF", :eot=>"Enabled"}
```

### Firmware update

Some of the Device commands require the latest firmware.

```irb
device.version
=> "Prologix GPIB-USB Controller version 6.107"
```

More details here:
http://prologix.biz/gpib-usb-6.0-firmware-update.html

Download FTDI drivers for Windows
https://ftdichip.com/wp-content/uploads/2021/08/CDM212364_Setup.zip

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/prologix_gpib.
