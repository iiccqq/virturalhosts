# virturalhosts
安装virturalbox、vagrant.载双击即可，本文实验用的mac版本
https://www.virtualbox.org/wiki/Downloads
https://www.vagrantup.com/downloads.html

vagrant box add centos/7 CentOS-7-x86_64-Vagrant-1801_02.VirtualBox.box
vagrant init centos/7   //这里可以省略，本项目已经创建完Vagrantfile，直接使用即可，配置一点profile
vagrant up
vagrant ssh
