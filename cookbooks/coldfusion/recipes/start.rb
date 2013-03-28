rightscale_marker :begin

ruby_block "start cf" do
  block do
    system "/opt/jrun4/bin/jrun start cfusion > /mnt/ephemeral/cf.log 2>&1 "
  end
end

until File.exists?('/mnt/ephemeral/cf.log') && open('/mnt/ephemeral/cf.log') { |f| f.grep(/Server cfusion ready/) }
  sleep(1)
end

rightscale_marker :end
