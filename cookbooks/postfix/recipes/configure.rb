rightscale_marker :begin

template "/etc/postfix/main.cf" do
  source "main.cf.erb"
  variables(
    :destinations => node[:postfix][:destinations],
    :networks => node[:postfix][:networks]
  )
end


rightscale_marker :end
