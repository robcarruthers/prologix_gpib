require 'thor'
require 'prologix_gpib'
require 'terminal-table'

module PrologixGpib
  class CLI < Thor
    desc 'list', 'List all connected controllers'
    def list
      if controller_connected?
        table =
          Terminal::Table.new do |t|
            t.title = 'Prologix Controllers'
            t.headings = %w[index Controller Version Path]
            PrologixGpib.controllers.each.with_index do |path, index|
              device = PrologixGpib::UsbController.new(path)
              str = device.version.split('version')
              t.add_row [index.to_s, str[0], str[1], path]
            end
          end
        puts table
      else
        puts 'No Prologix Controllers available.'
      end
    end
    desc 'version', 'Display the device version'
    def version
      return unless controller_connected?

      PrologixGpib.controllers.each do |device_path|
        PrologixGpib::UsbController.new(device_path) { |controller| puts "#{device_path} - #{controller.version}" }
      end
    end

    private

    def controller_connected?
      PrologixGpib.controllers.count >= 1
    end
  end
end
