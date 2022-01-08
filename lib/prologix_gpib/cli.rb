require 'thor'
require 'pp'
require 'prologix_gpib'
require 'terminal-table'

module PrologixGpib
  class CLI < Thor
    desc 'list', 'List all connected controllers'

    def list
      if controllers_connected?
        table =
          Terminal::Table.new do |t|
            t.title = 'Prologix Controllers'
            t.headings = %w[index Controller Version Path]
            PrologixGpib.controller_paths.each.with_index do |path, index|
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

    desc 'info', 'Display Controller information'
    option :path, alias: :p
    def info
      return unless controllers_connected?

      paths = options[:path].nil? ? PrologixGpib.controller_paths : [options[:path]]

      paths.each do |path|
        hash = PrologixGpib::UsbController.new(path).config
        puts "\n  #{titleise hash.delete(:device_name)}"
        puts "\tPath: #{path}"
        hash.each { |k, v| puts "\t#{titleise(k)}: #{v}" }
      end
    end

    private

    def controllers_connected?
      PrologixGpib.controller_paths.count >= 1
    end

    def titleise(string)
      string.to_s.split('_').map(&:capitalize).join(' ')
    end
  end
end
