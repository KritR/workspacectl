require 'yaml'
require 'optparse'

CONFIG = File.expand_path("~/.config/wsctl/config.yml")

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
  opts.on("-k", "--keep", "Keeps existing applications open") do
    options[:keep] = true
  end
end.parse!

ws = ARGV.pop
ws ||= "default"

raise "Config not specified at #{CONFIG}" unless File.exists?(CONFIG)

begin
  workspaces = read_config(CONFIG)
  if ws == "clear"
    clear
    exit
  end
  raise "Workspace [#{ws}] not defined in Config" unless workspaces.has_key?(ws)
  clear unless options[:keep]
  workspaces[ws].each do |app|
    open(app)
    puts "Launching #{app}" if options[:verbose]
  end
rescue Psych::SyntaxError => ex
  raise ex.message
end
