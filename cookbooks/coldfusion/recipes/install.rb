rightscale_marker :begin

require 'aws/s3'

AWS::S3::Base.establish_connection!(
    :access_key_id     => node[:coldfusion][:amazon][:aws_key],
    :secret_access_key => node[:coldfusion][:amazon][:aws_secret]
)

bucketfile = S3Object.find node[:coldfusion][:s3][:dl_file], node[:glusterfs][:s3][:dl_bucket]

file "/tmp/#{node[:coldfusion][:s3][:file_prefix]}.bin" do
  content bucketfile.value
end

package "php-apc"

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
