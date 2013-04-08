rightscale_marker :begin

ruby_block "stop cf" do
  block do
    system "/opt/jrun4/bin/jrun stop cfusion"
  end
end

File.unlink '/opt/jrun4/logs/cfserver.log' if File.exists?('/opt/jrun4/logs/cfserver.log');

rightscale_marker :end
