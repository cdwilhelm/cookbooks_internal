rightscale_marker :begin

case node[:platform]
when "ubuntu","debian"
  ruby_block "wsconfig" do
    block do
      system "echo 'Include httpd.conf' >> /etc/apache2/apache2.conf"
      system "/opt/jrun4/runtime/bin/wsconfig -server coldfusion -ws Apache -dir /etc/apache2 -bin /usr/sbin/apache2 -script /usr/sbin/apache2ctl -coldfusion -v"
    end
  end
when "centos"
  package "httpd-devel"
  ruby_block "wsconfig" do
    block do
      system "/opt/jrun4/runtime/bin/wsconfig -server coldfusion -ws Apache -dir /etc/httpd/conf -bin /usr/sbin/httpd -script /usr/sbin/apachectl -coldfusion -v"
    end
  end
end

rightscale_marker :end
