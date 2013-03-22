rightscale_marker :begin

ruby_block "start celery" do
  block do
    system "celeryd --pidfile=/var/run/celery.pid"
  end
end
rightscale_marker :end
