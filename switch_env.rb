#!/usr/bin/env ruby

require_relative 'env_config'

FILE = "index.html"

def current_env
  content = File.read(FILE)
  if content.include?(LOCAL_API)
    "local"
  elsif content.include?(PROD_API)
    "prod"
  else
    "unknown"
  end
end

def switch_to_local
  content = File.read(FILE)
  content.gsub!(PROD_API, LOCAL_API)
  content.gsub!(/const STRIPE_KEY = '#{Regexp.escape(LIVE_STRIPE)}'/, "const STRIPE_KEY = '#{TEST_STRIPE}'")
  File.write(FILE, content)
  puts "✅ Switched to LOCAL (test keys)"
end

def switch_to_prod
  content = File.read(FILE)
  content.gsub!(LOCAL_API, PROD_API)
  content.gsub!(/const STRIPE_KEY = '#{Regexp.escape(TEST_STRIPE)}'/, "const STRIPE_KEY = '#{LIVE_STRIPE}'")
  File.write(FILE, content)
  puts "✅ Switched to PROD (live keys)"
end

# Main
case ARGV[0]
when "--local", "-l"
  switch_to_local
when "--prod", "-p"
  switch_to_prod
when "--status", "-s"
  puts "Current environment: #{current_env}"
else
  puts "Usage:"
  puts "  ruby switch_env.rb --local   # Switch to local (test)"
  puts "  ruby switch_env.rb --prod    # Switch to production (live)"
  puts "  ruby switch_env.rb --status  # Check current env"
end