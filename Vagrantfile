Vagrant.configure(2) do |config|
    config.ssh.insert_key = false

    config.vm.define "centos7" do |centos|
        centos.vm.box = "bento/centos-7.3"
        centos.vm.hostname = "centos7"
        centos.vm.synced_folder ".", "/home/vagrant/singularity-containers"
        centos.vm.provider "virtualbox" do |virtualbox|
            virtualbox.name = "centos7"
            virtualbox.customize ["modifyvm", :id, "--cpus", 2]
            virtualbox.customize ["modifyvm", :id, "--memory", 1024]
            virtualbox.customize ["modifyvm", :id, "--vram", 12]
            virtualbox.customize ["modifyvm", :id, "--ioapic", "on"]
        end

        centos.vm.provision "shell",
            path: "vagrant_bootstrap.sh"
    end
 end
