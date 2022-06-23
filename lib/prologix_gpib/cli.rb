require 'thor'
require 'pp'
require 'prologix_gpib'
require 'terminal-table'
require 'resolv'

module PrologixGpib
  class CLI < Thor
    def initialize(*args)
      super
      @controllers = PrologixGpib::Finder.new.avaliable_controllers
    end

    desc 'list', 'List all connected controllers'

    def list
      puts controller_table(@controllers)
    end

    desc 'info [INDEX]', 'Display Controller information'
    option :path, aliases: :p
    def info(index)
      return unless controllers_connected?

      controller_paths = @controllers.map { |k, v| v }.flatten

      path = controller_paths[index.to_i]
      hash = ip_address?(path) ? PrologixGpib::LanController.new(path).config : PrologixGpib::UsbController.new(path).config

      puts "\n  #{titleise hash.delete(:device_name)}"
      puts "\tPath: #{path}"
      hash.each { |k, v| puts "\t#{titleise(k)}: #{v}" }
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
      @controllers[:usb].any? || @controllers[:lan].any?
    end

    def titleise(string)
      string.to_s.split('_').map(&:capitalize).join(' ')
    end

    def ip_address?(string)
      string =~ Resolv::IPv4::Regex ? true : false
    end
  end
end
