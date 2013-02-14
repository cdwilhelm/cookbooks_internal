rightscale_marker :begin

repo "default" do
  destination node[:postfix][:deploy_dir]
  action :pull
  user "root"
  repository node[:postfix][:repository]
  persist false
end

rightscale_marker :end
