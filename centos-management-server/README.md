Vagrant Environment for Cloudstack Management Server
====================================================

This project provides a Vagrant environment for a CloudStack Management Server. It runs on Centos 6.5 and contains a Chef Cookbook that installs CloudStack Management Server from packages.

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

    ssh root@192.168.56.100

with password `password`

After the provisioning, the CloudStack Management server should be accessible via [http://192.168.56.100:8080/client/](http://192.168.56.100:8080/client/)



Troubleshooting
===============

CloudStack Management server logs to `/var/log/cloudstack/management/management-server.log` see [TroubleShooting Guide](http://cloudstack-administration.readthedocs.org/en/latest/troubleshooting.html) for further information.



Resources
=========

The installation routine follows this documentation: http://cloudstack-installation.readthedocs.org/en/latest/qig.html


Author
======

Michael Lihs - [http://lihsmi.ch](http://lihsmi.ch)
