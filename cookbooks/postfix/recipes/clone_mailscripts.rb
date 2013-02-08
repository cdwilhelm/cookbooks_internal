rightscale_marker :begin

repo "mailscripts" do
  destination node[:postfix][:deploy_dir]
  action :pull
  app_user node[:postfix][:user]
  repository node[:postfix][:repository]
  persist false
end

rightscale_marker :end
