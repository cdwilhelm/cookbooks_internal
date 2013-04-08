rightscale_marker :begin

ruby_block "start cf" do
  block do
    system "/opt/jrun4/bin/coldfusion start"
  end
end

x = 0
until File.exists?('/opt/jrun4/logs/cfserver.log') && open('/opt/jrun4/logs/cfserver.log') { |f| f.grep(/Server coldfusion ready/) }
  x += 1
  sleep(1)
  if x == 300
    break
  end
end

rightscale_marker :end
