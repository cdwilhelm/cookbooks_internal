rightscale_marker :begin

cookbook_file "/opt/rightscale/ebs/ec2_ebs_utils.rb" do
  source "ec2_ebs_utils.rb"
  mode "0644"
end

rightscale_marker :end
