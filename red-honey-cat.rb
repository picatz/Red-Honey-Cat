#!/usr/bin/env ruby
# Kent 'picat' Gruber
# RED HONEY CAT
# Based on by Hood3dRob1n's RubyCat and Honey Cat, a netcat honey pot I wrote in BASH

# For a presentation at YoloCon 2016 on Ruby

require 'optparse'
require 'socket'
require 'logger'

module Logging
  # This is the magical bit that gets mixed into your classes
  def logger
    Logging.logger
  end

  # Global, memoized, lazy initialized instance of a logger
  def self.logger
      @logger ||= Logger.new 'hcat.log'
  end
end
 
def script_banner
  puts "RED HONEY CAT \n"
end

def version
  puts "Version : 1.0"
end
 
def cls
  if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
    system('cls')
  else
    system('clear')
  end
end
 
class HoneyCat
  include Logging
		
  def listener(port,banner=nil)

		# check if banner is set or not
		if banner.nil?
			banner = 'MS-IIS WEB SERVER 5.0'
		else
			banner = banner
		end

    logger.info("STARTING HONEYPOT ON PORT #{port} -- #{banner}")
    puts "Setting up Listener on port #{port}...."
    
    # Spawn server
    server = TCPServer.new(port)
    # Listen for connections
    server.listen(1)
    
    loop do 
      # wait for a client to connect
      client = server.accept
      
      # extract the IP and PORT the hacker is using.
      hacker_port, hacker_ip = Socket.unpack_sockaddr_in(client.getpeername)
      
      puts "Connection from #{hacker_ip}"
      # Log more events.
      logger.warn("CONNECTION MADE TO HONEYPOT")
      logger.warn("HONEYPOT CAUGHT -- FROM IP: #{hacker_ip} -- FROM PORT: #{hacker_port}")
      
      # Provide a fake banner. 
      client.puts banner

      puts "Closing out connection."
      logger.info("CLOSING CONNECTION")
      client.close
    end
  end
end
 
options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [OPTIONS]"
  opts.separator ""
  opts.separator "EX: #{$0} -p 31337"
  opts.separator ""
  opts.separator "Options: "
  opts.on('-p', '--port <PORT>', "Define the port to start honeypot on.") do |port|
    options[:port] = port.to_i
    options[:method] = 0
  end
	opts.on('-b', '--banner <BANNER>', "Define a custom banner to be set for your honeypot.") do |banner|
		options[:banner] = banner.to_s
		options[:method] = 1
	end
	opts.on('-l', '--lol', "Rainbow support, because we need it.") do 
    require 'lolize/auto'
  end
	opts.on('-v', '--version', "Show verison number.") do 
    script_banner
    version
    exit
  end
  opts.on('-h', '--help', "Help menu.") do
    cls
		script_banner
    puts
    puts opts
    puts
    exit
  end
end

begin
  optparse.parse!
  if options[:method].to_i == 0
    mandatory = [:port]
  elsif options[:method].to_i == 1
    mandatory = [:banner]
  end
  missing = mandatory.select{ |param| options[param].nil? }
  if not missing.empty?
    cls
    script_banner
    puts
    puts "Missing options: #{missing.join(', ')}"
    puts optparse
    puts
    exit
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  cls
  script_banner
  puts
  puts $!.to_s
  puts
  puts optparse
  puts
  exit
end

# CTRL+C Interupt 
trap("SIGINT") { puts "\n\nCTRL+C Detected! \nClosing Connections + Shutting down..."; exit;}

rc = HoneyCat.new
 
case options[:method].to_i
when 0
	# use default banner
  rc.listener(options[:port])
when 1
	rc.listener(options[:port],options[:banner])
end
