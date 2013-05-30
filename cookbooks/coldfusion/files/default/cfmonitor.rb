#!/usr/bin/env ruby
require 'getoptlong'

# The name of the collectd plugin, something like apache, memory, mysql, interface, ...
PLUGIN_NAME = 'coldfusion'

def usage
  puts("#{$0} -h <host_id> [-i <sampling_interval>]")
  exit
end

# Main
begin
  # Sync stdout so that it will flush to collectd properly. 
  $stdout.sync = true

  # Parse command line options
  hostname = nil
  sampling_interval = 20  # sec, Default value
  opts = GetoptLong.new(
    [ '--hostid', '-h', GetoptLong::REQUIRED_ARGUMENT ],
    [ '--sampling-interval', '-i',  GetoptLong::OPTIONAL_ARGUMENT ]
  )
  opts.each do |opt, arg|
    case opt
      when '--hostid'
        hostname = arg
      when '--sampling-interval'
        sampling_interval = arg.to_i
    end
  end
  usage if !hostname

  # Collection loop
  while true do
    start_run = Time.now.to_i
    next_run = start_run + sampling_interval

    # collectd data and print the values

    #Pg/Sec  DB/Sec  CP/Sec  Reqs  Reqs  Reqs  AvgQ   AvgReq AvgDB  Bytes  Bytes
    #Now Hi  Now Hi  Now Hi  Q'ed  Run'g TO'ed Time   Time   Time   In/Sec Out/Sec
    #0   0   0   0   -1  -1  0     0     7     0      689    3      0      0

    data = `/opt/jrun4/bin/cfstat -n`[/(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)\s+(-?[\d]*)/]
    puts("PUTVAL #{hostname}/#{PLUGIN_NAME}/gauge-reqs_queued #{start_run}:#{$7}")
    puts("PUTVAL #{hostname}/#{PLUGIN_NAME}/counter-reqs_timed_out #{start_run}:#{$9}")
    puts("PUTVAL #{hostname}/#{PLUGIN_NAME}/gauge-avg_req_time #{start_run}:#{$11}")
    puts("PUTVAL #{hostname}/#{PLUGIN_NAME}/gauge-avg_db_time #{start_run}:#{$12}")

    # sleep to make the interval
    while((time_left = (next_run - Time.now.to_i)) > 0) do
      sleep(time_left)
    end
  end
end
