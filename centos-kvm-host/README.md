Vagrant Environment for Cloudstack KVM Host
===========================================

This project provides a Vagrant environment for a CloudStack KVM host. It runs on Centos 6.5 and contains a Chef Cookbook that installs a CloudStack KVM host from packages.

Prerequisites
-------------

* VirtualBox - [download here](https://www.virtualbox.org/wiki/Downloads)
* Vagrant - [download here](http://www.vagrantup.com/downloads.html)
* Bundler - `gem install bundler`



Setup
=====

From root of the centos-management-server directory (where Vagrantfile is located), run

    bundle install
    berks vendor -b cookbooks/app_cloudstack_management_server/Berksfile  berks-cookbooks
    vagrant up

You can then ssh into the machine with

    ssh root@192.168.56.101

with password `password`



Troubleshooting
===============

The CloudStack agent logs to `/var/log/cloudstack/agent/agent.log`



Resources
=========

The installation routine follows this documentation: http://cloudstack-installation.readthedocs.org/en/latest/qig.html


Author
======

Michael Lihs - [http://lihsmi.ch](http://lihsmi.ch)
