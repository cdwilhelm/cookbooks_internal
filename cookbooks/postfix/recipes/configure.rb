rightscale_marker :begin

template "/etc/postfix/main.cf" do
  source "main.cf.erb"
  variables(
    :destinations => node[:postfix][:destinations],
    :networks => node[:postfix][:networks]
  )
end

include_recipe "postfix::restart"

rightscale_marker :end
