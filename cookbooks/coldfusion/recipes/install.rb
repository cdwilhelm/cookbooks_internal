rightscale_marker :begin

require 'rubygems' 
require 'right_aws' 

s3= RightAws::S3Interface.new(node[:coldfusion][:amazon][:aws_key],node[:coldfusion][:amazon][:aws_secret])
localfile = File.new("/tmp/#{node[:coldfusion][:s3][:file_prefix]}.bin" , File::CREAT|File::RDWR)
rhdr = s3.get(node[:coldfusion][:s3][:dl_bucket], node[:coldfusion][:s3][:dl_file]) do |chunk|
  localfile.write(chunk)
end
localfile.close

template "/tmp/cf902silent.properties" do
  source "cf902silent.properties.erb"
  variables(
    :serial_number => node[:coldfusion][:serial_number],
    :previous_serial => node[:coldfusion][:previous_serial],
    :admin_password => node[:coldfusion][:admin_password]
  )
end

ruby_block "cf install" do
  block do
    system "/tmp/#{node[:coldfusion][:s3][:file_prefix]}.bin -f /tmp/cf902silent.properties"
  end 
end


rightscale_marker :end
