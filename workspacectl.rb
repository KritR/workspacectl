require 'yaml'
require 'optparse'

CONFIG = File.expand_path("~/.workspacectl/config.yml")

def clear
  `pkill -u $(whoami)`
end

def open(item)
  if /^\w+:\/\//.match?(item)
    `open #{item}`
  else
    `open -a #{item}`
  end
end

def read_config(filepath)
  Psych.load_file(filepath)
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: workspacectl.rb [workspace]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

ws = ARGV.pop
ws ||= "default"

raise "Config not specified at #{CONFIG}" unless File.exists?(CONFIG)

begin
  workspaces = read_config(CONFIG)
  raise "Workspace [#{ws}] not defined in Config" unless workspaces.has_key?(ws)
  clear
  workspaces[ws].each do |app|
    output = open(app)
    puts output if options[:verbose]
  end
rescue Psych::SyntaxError => ex
  raise ex.message
end
