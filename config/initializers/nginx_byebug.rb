require 'byebug/core'

if Rails.env.development?
  begin
    Byebug.start_server 'localhost', ENV.fetch("BYEBUG_SERVER_PORT", 1048).to_i # note change this per project
  rescue Errno::EADDRINUSE => e
    puts 'Byebug server already running on port ' + ENV.fetch("BYEBUG_SERVER_PORT", 1048).to_i.to_s
  end
end
