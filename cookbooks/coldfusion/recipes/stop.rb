rightscale_marker :begin

ruby_block "stop cf" do
  block do
    system "/opt/jrun4/bin/jrun stop cfusion"
  end
end

File.unlink '/tmp/cf.log' if File.exists?('/tmp/cf.log');

rightscale_marker :end
