rightscale_marker :begin

require 'aws/s3'

AWS::S3::Base.establish_connection!(
    :access_key_id     => node[:glusterfs][:server][:aws_access_key_id],
    :secret_access_key => node[:glusterfs][:server][:aws_access_key_secret]
)
BUCKET_NAME = node[:glusterfs][:server][:bucket_name]

objects = Bucket.objects(BUCKET_NAME);

objects.each do |file|
  file.path
end

rightscale_marker :end
