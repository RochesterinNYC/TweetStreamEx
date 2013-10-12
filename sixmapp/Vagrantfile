# encoding: utf-8

# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.hostname = "app"
  config.vm.network "forwarded_port", guest: 23, host: 2323
  config.vm.network "private_network", ip: "192.168.50.4"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe :apt
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'nodejs'
    chef.add_recipe 'rbenv::vagrant'
    chef.add_recipe 'rbenv::user'
    chef.add_recipe 'git'
    chef.add_recipe 'redis'
    chef.add_recipe 'tmux'
    chef.add_recipe 'nginx'
    chef.add_recipe 'postgresql::server'
    chef.add_recipe 'vim'
    chef.json = {
      "nodejs" => {
        "version" => "0.10.12"
      },
      :rbenv      => {
        :user_installs => [
          {
            :user   => "vagrant",
            :rubies => [
              "2.0.0-p247"
            ],
            :global => "2.0.0-p247"
          }
        ]
      },
      :git        => {
        :prefix => "/usr/local"
      },
      :redis      => {
        :bind        => "127.0.0.1",
        :port        => "6379",
        :config_path => "/etc/redis/redis.conf",
        :daemonize   => "yes",
        :timeout     => "300",
        :loglevel    => "notice"
      },
      :nginx      => {
        :dir                => "/etc/nginx",
        :log_dir            => "/var/log/nginx",
        :binary             => "/usr/sbin/nginx",
        :user               => "www-data",
        :init_style         => "runit",
        :pid                => "/var/run/nginx.pid",
        :worker_connections => "1024"
      },
      :postgresql => {
        :version  => "9.1",
        :config   => {
          :listen_addresses => "*",
          :port             => "5432"
        },
        :pg_hba   => [
          {
            :type   => "local",
            :db     => "postgres",
            :user   => "postgres",
            :addr   => nil,
            :method => "trust"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "0.0.0.0/0",
            :method => "md5"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "::1/0",
            :method => "md5"
          }
        ],
        :password => {
          :postgres => "password"
        }
      },
      :vim        => {
        :extra_packages => [
          "vim-rails"
        ]
      }
    }
  end

  config.vm.provision "shell", path: "provisioning/provision.sh"
end
