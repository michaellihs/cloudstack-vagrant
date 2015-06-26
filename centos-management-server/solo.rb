# -*- mode: ruby -*-
# vi: set ft=ruby :

# This is required to run vagrant with chef solo

file_cache_path "/var/chef-cache"
cookbook_path ["/var/vagrant/cookbooks", "/var/vagrant/berks-cookbooks"]
ssl_verify_mode :verify_none