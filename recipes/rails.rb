include_recipe "stronglifters::user"
include_recipe "stronglifters::aws"

root_path = node["stronglifters"]["root_path"]
shared_path = File.join(root_path, "shared")

template "/etc/logrotate.d/rails" do
  source "rails_logrotate.erb"
  mode "0644"
  variables({ shared_path: shared_path })
end

template "/home/#{node["stronglifters"]["username"]}/.profile" do
  variables(env: node["stronglifters"]["env"])
end

directory "#{shared_path}/config" do
  mode "0755"
  owner node["stronglifters"]["username"]
  group node["stronglifters"]["username"]
  recursive true
end

file "#{shared_path}/config/database.yml" do
  content <<-YAML
production:
  url: <%= ENV['DATABASE_URL'] %>
YAML
end

gem "foreman"

runit_service "foreman" do
  action [:enable, :start]
  default_logger true
  env node["stronglifters"]["env"]
  log true
  log_size 1_000_000
  log_num 31
  retries 3
end if File.exists?("#{File.join(root_path, "current")}/Procfile")
