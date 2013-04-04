rightscale_marker :begin

bash "symfony submodules" do
 installation_dir = "/home/webapps/#{node[:symfony][:application]}"
 cwd installation_dir
 code <<-EOF
   git submodule init
   git submodule update
 EOF
 creates installation_dir + "/symfony/lib/vendor/symfony/LICENSE"
end

rightscale_marker :end
