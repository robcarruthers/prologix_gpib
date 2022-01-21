require 'thor'
require 'pp'
require 'prologix_gpib'
require 'terminal-table'

module PrologixGpib
  class CLI < Thor
    desc 'list', 'List all connected controllers'

    def list
      puts controller_table(PrologixGpib::Finder.new.avaliable_controllers)
    end

    desc 'info', 'Display Controller information'
    option :path, alias: :p
    def info
      return unless controllers_connected?

      paths = options[:path].nil? ? PrologixGpib.usb_paths : [options[:path]]

      paths.each do |path|
        hash = PrologixGpib::UsbController.new(path).config
        puts "\n  #{titleise hash.delete(:device_name)}"
        puts "\tPath: #{path}"
        hash.each { |k, v| puts "\t#{titleise(k)}: #{v}" }
      end
    end

    private

    def controller_table(controllers)
      return 'No Prologix Controllers available.' unless controllers.length > 0

      table =
        Terminal::Table.new do |t|
          t.title = 'Prologix Controllers'
          t.headings = %w[index Controller Version Location]
        end

      index = 0
      if controllers.key? :usb
        controllers[:usb].each do |path|
          device = PrologixGpib::UsbController.new(path)
          str = device.version.split('version')
          table.add_row [index.to_s, str[0], str[1], path]
          index += 1
        end
      end

      if controllers.key? :lan
        controllers[:lan].each do |ip|
          device = PrologixGpib::LanController.new(ip)
          str = device.version.split('version')
          table.add_row [index.to_s, str[0], str[1], ip]
          index += 1
        end
      end
      table
    end

    def controllers_connected?
      PrologixGpib.usb_paths.count >= 1
    end

    def titleise(string)
      string.to_s.split('_').map(&:capitalize).join(' ')
    end
  end
end
