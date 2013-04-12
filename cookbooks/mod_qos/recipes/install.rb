rightscale_marker :begin

package "openssl-devel"
package "pcre-devel"
package "httpd-devel"

cookbook_file "/tmp/mod_qos-10.14.tar.gz" do
  source "mod_qos-10.14.tar.gz"
  mode 0644
  owner "root"
  group "root"
end

bash 'extract module' do
  cwd "/tmp"
  code <<-EOH
    tar xzf /tmp/mod_qos-10.14.tar.gz
    apxs -i -c mod_qos-10.14/apache2/mod_qos.c
    echo "LoadModule qos_module /usr/lib64/httpd/modules/mod_qos.so" >> /etc/httpd/conf/httpd.conf
    EOH
  not_if { File.exists?("/usr/lib64/httpd/modules/mod_qos.so") }
  notifies :restart, resources(:service => "apache2")
end

rightscale_marker :end
