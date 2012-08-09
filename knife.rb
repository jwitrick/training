current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "jwitrick-laptop"
client_key               "#{current_dir}/jwitrick-laptop.pem"
validation_client_name   "chef-validator"
validation_key           "#{current_dir}/validation.pem"
chef_server_url          "http://108.166.114.173:4000"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
knife[:flavor] = 'm1.small'
knife[:image] = 'ami-3c994355'
knife[:distro] = 'chef-full'

