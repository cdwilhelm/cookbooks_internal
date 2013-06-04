rightscale_marker :begin
ruby_block "running garbage collection" do
  block do
    system "curl #{node[:coldfusion][:tasks][:username]}:#{node[:coldfusion][:tasks][:password]}localhost:8000/tasks2/garbage_collect.cfm"
  end
end
rightscale_marker :end
