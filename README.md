# PrologixGpibUsb

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/prologix_gpib_usb`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

Uses the Prologix GPIB-USB controller to talk to a GPIB device.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prologix_gpib_usb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prologix_gpib_usb

## Usage

TODO: Write better usage instructions here

## Firmware update

Some of the Device commands require the latest firmware.

```irb
device.version
=> "Prologix GPIB-USB Controller version 6.107"
```

More details here:
http://prologix.biz/gpib-usb-6.0-firmware-update.html

Download FTDI drivers for Windows
https://ftdichip.com/wp-content/uploads/2021/08/CDM212364_Setup.zip

## Playing in Console

Open irb inside the gem folder

```bash
$ bin/console
```

With the Prologix GPIB/USB connected

```ruby
irb(main):001:0> device = GpibUsb.new(:controller, device_address: 8)
=> #<GpibUsb:0x00007fc1bb2fed90>

irb(main):002:0> device.open
=> true

irb(main):003:0> device.version
=> "Prologix GPIB-USB Controller version 6.107"

irb(main):004:0> device.auto = :listen
=> :listen
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/prologix_gpib_usb.
