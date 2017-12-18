# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "dummy"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", guest: 80, host: 8867
  config.vm.network "forwarded_port", id: "ssh", guest: 22, host: 2371

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.94"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.
  config.vm.provider :aws do |aws, override|
    # IAMで取得したアクセスキーID
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']

    # IAMで取得したシークレットアクセスキー
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    # 作成したキーペアの名称
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']

    aws.instance_type = "t2.micro"
    # リージョン（東京はap-northeast-1）
    aws.region = "ap-northeast-1"
    # アベイラビリティゾーン
    aws.availability_zone = "ap-northeast-1a"

    aws.ami = "ami-da9e2cbc"

    #aws.subnet_id = ENV['AWS_SUBNET_ID']
    # VPC内のローカルIPアドレスを指定
    #aws.private_id_address = '192.168.0.33'
    # 自動的にEIPを割り当てる場合（EIPの取得上限は5個のためそれ以上の指定はエラーとなる）
    aws.elastic_ip = true
    # ELBを指定
    # aws.elb = "production-web"

    override.ssh.username = "ec2-user"
    override.ssh.private_key_path = ENV['AWS_PRIVATE_KEY_PATH']
    override.nfs.functional = false

    aws.security_groups = [ENV['AWS_SECURITY_GROUP']]
  # 以下はVagrant_chefのREADMEより抜粋
  # An array of security groups for the instance. If this instance will be launched in VPC, this must be a list of security group Name. For a nondefault VPC, you must use security group IDs instead (http://docs.aws.amazon.com/cli/latest/reference/ec2/run-instances.html).

  # 以下はSSH上でsudoを実行できるようにするために必要。
  config.ssh.pty=true
  aws.user_data =<<USER_DATA
#!/bin/sh
sed -i -e 's/^\\(Defaults.*requiretty\\)/#\\1/' /etc/sudoers
USER_DATA
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  config.vm.provision "shell", :path => "provision_init.sh", :privileged => false
end
