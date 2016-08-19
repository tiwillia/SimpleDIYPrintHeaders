#!/usr/bin/env ruby

require 'socket' # Provides TCPServer and TCPSocket classes
require 'digest/sha1'

#Taken from default web server
#config = {}
#config.update(:Port => 8080)
#config.update(:BindAddress => ARGV[0])
#config.update(:DocumentRoot => ARGV[1])
#server = HTTPServer.new(config)


server = TCPServer.new(ARGV[0], 8080)

loop do

  # Wait for a connection
  socket = server.accept
  STDERR.puts "Incoming Request"

  # Read the HTTP request. We know it's finished when we see a line with nothing but \r\n
  http_request = ""
  while (line = socket.gets) && (line != "\r\n")
    http_request += line 
  end

  STDERR.puts "HTTP REQUEST: #{http_request}"

  # Grab the security key from the headers. If one isn't present, close the connection.
  if matches = http_request.match(/^Sec-WebSocket-Key: (\S+)/)
    websocket_key = matches[1]
    STDERR.puts "Websocket handshake detected with key: #{ websocket_key }"
  else
    STDERR.puts "Aborting non-websocket connection"
    socket.close
    next
  end

  socket.close
end

