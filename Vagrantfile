VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.hostname = "docker-elasticsearch-vagrant"
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "172.20.20.11"

  config.vm.provision "docker" do |d|
    d.build_image "/vagrant", args: "-t jgoodall/elasticsearch-etcd"
    d.run "jgoodall/elasticsearch-etcd"
  end

end