rightscale_marker :begin

ruby_block "start cf" do
  block do
    system "/opt/jrun4/bin/jrun start cfusion > /tmp/cf.log 2>&1 "
  end
end

until open('/tmp/cf.log') { |f| f.grep(/Server cfusion ready/) }
  wait(1)
end

rightscale_marker :end
