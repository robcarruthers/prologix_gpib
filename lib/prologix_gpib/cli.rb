require 'thor'
require 'pp'
require 'prologix_gpib'
require 'terminal-table'
require 'resolv'

module PrologixGpib
  class CLI < Thor
    desc 'list', 'List available Prologix Controllers'

    option :usb, aliases: :u
    option :lan, aliases: :l

    def list
      if options[:usb]
        @controllers = PrologixGpib::Finder.new.avaliable_controllers(:usb) if options[:usb]
      elsif options[:lan]
        @controllers = PrologixGpib::Finder.new.avaliable_controllers(:lan) if options[:lan]
      else
        @controllers = PrologixGpib::Finder.new.avaliable_controllers
      end
      puts controller_table
    end

    desc 'info [INDEX]', 'Display Controller information'

    option :path, aliases: :p

    def info(index)
      @controllers = PrologixGpib::Finder.new.avaliable_controllers
      return unless controllers_connected?

      path = options[:path] ? options[:path] : controller_paths[index.to_i]
      hash = ip_address?(path) ? PrologixGpib::LanController.new(path).config : PrologixGpib::UsbController.new(path).config

      puts "\n  #{titleise hash.delete(:device_name)}"
      puts "\tPath: #{path}"
      hash.each { |k, v| puts "\t#{titleise(k)}: #{v}" }
    end

    private

    def controller_table
      return 'No Prologix Controllers available.' unless @controllers.length > 0

      table =
        Terminal::Table.new do |t|
          t.title = 'Prologix Controllers'
          t.headings = %w[index Controller Version Location]
        end

      controller_paths.each.with_index do |path, index|
        device = ip_address?(path) ? PrologixGpib::LanController.new(path) : PrologixGpib::UsbController.new(path)
        str = device.version.split('version')
        table.add_row [index.to_s, str[0], str[1], path]
      end

      table
    end

    def controller_paths
      @controllers.map { |k, v| v }.flatten
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
