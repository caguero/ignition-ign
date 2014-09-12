require 'dl/import'
require 'optparse'
require 'yaml'
require "ignition/ign/version"

module Ignition
  module Ign
    extend DL::Importer

    commands = {}

    conf_directory = '/usr/share/ignition/'
    conf_directory = ENV['IGN_CONFIG_PATH'] if ENV.key?('IGN_CONFIG_PATH')

    # Check that we have at least one configuration file with ign commands.
    if Dir.glob(conf_directory + '/*.yaml').empty?
      puts 'I cannot find any available "ign" command:'
      puts "\t* Did you install any ignition library?"
      puts "\t* Did you set the IGN_CONFIG_PATH environment variable?"
      puts "\t    E.g.: export IGN_CONFIG_PATH=$HOME/local/share/ignition"
      exit(-1)
    end

    # Iterate over the list of configuration files.
    Dir.glob(conf_directory + '/*.yaml') do |conf_file|
      next if conf_file == '.' || conf_file == '..'

      # Read the configuration file.
      yml = YAML.load_file(conf_file)
      yml['commands'].each do |cmd|
        cmd.each do |key, value|
          commands[key] = { 'library' => yml['library'], 'description' => value }
        end
      end
    end

    # Debug: show the list of available commands.
    # puts commands

    # Read the command line arguments.
    usage = 'The ign command provides a command line interface to the ignition '\
            "tools.\n\n"\
            "  Usage: ign [options] command\n\n"\
            "List of available commands:\n\n"

    commands.each do |cmd, value|
      usage += cmd + "\t" + value['description'] + "\n"
    end

    usage += "\nUse \"ign help <command>\" to print help for a command"

    OptionParser.new do |opts|
      opts.banner = usage

      opts.on('-h', '--help', 'Show this message') do
        puts opts
        exit(0)
      end
    end.parse!

    # Check that there is at least one command and there is a plugin that knows
    # how to handle it.
    if ARGV.empty? || !commands.key?(ARGV[0])
      puts usage
      exit(-1)
    end

    # Read the plugin that handles the command.
    plugin = commands[ARGV[0]]['library']

    ARGV.insert(0, 'ign')

    dlload plugin
    extern 'void execute(int, char**)'
  end
end
