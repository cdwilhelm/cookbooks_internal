rightscale_marker :begin

File.unlink '/opt/jrun4/logs/cfserver.log' if File.exists?('/opt/jrun4/logs/cfserver.log');

ruby_block "restart cf" do
  block do
    system "/opt/jrun4/bin/coldfusion restart"
  end
end

x = 0
until File.exists?('/opt/jrun4/logs/cfserver.log') && open('/opt/jrun4/logs/cfserver.log') { |f| f.grep(/Server coldfusion ready/) }
  x += 1
  sleep(1)
  if x == 500
    break
  end
end

rightscale_marker :end
