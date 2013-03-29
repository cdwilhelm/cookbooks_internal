rightscale_marker :begin

ruby_block "start cf" do
  block do
    system "/opt/jrun4/bin/jrun start cfusion >2 /tmp/cf.log &"
  end
end

x = 0
until File.exists?('/tmp/cf.log') && open('/tmp/cf.log') { |f| f.grep(/Server cfusion ready/) }
  x += 1
  sleep(1)
  if x == 300
    break
  end
end

rightscale_marker :end
