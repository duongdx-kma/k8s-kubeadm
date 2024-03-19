NUM_MASTER_NODE = 2 # add standby master - recommend 3, 5, 7 master_node
NUM_WORKER_NODE = 2

IP_NW = "192.168.56."
MASTER_IP_START = 1
NODE_IP_START = 5

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.box_check_update = false

  config.vm.define "loadbalancer" do |loadbalancer|
  		loadbalancer.vm.provider "virtualbox" do |vb|
  			vb.name = "loadbalancer"
  		end
  		loadbalancer.vm.hostname = "loadbalancer"
  		loadbalancer.vm.network :private_network, ip: IP_NW + "99"
  		loadbalancer.vm.provision "setup-nginx", type: "shell", :path => "ubuntu/nginx.sh"
  		loadbalancer.vm.provision "setup-dns", type: "shell", :path => "ubuntu/update-dns.sh"
  end

  # provision master node
  (1..NUM_MASTER_NODE).each do |i|
	config.vm.define "kubemaster#{i}" do |node|
		node.vm.provider "virtualbox" do |vb|
			vb.name = "kubemaster#{i}"
			vb.memory = 2048
			vb.cpus = 2
		end
		node.vm.hostname = "kubemaster#{i}"
		node.vm.network :private_network, ip: IP_NW + "#{MASTER_IP_START + i}"
		node.vm.network "forwarded_port", guest: 22, host: "#{2710 + i}"
		node.vm.provision "setup-hosts", :type => "shell", :path => "ubuntu/vagrant/setup-hosts.sh" do |s|
			s.args = ["enp0s8"]
		end

		node.vm.provision "setup-container-runtime", type: "shell", :path => "ubuntu/install-docker.sh"

		node.vm.provision "setup-dns", type: "shell", :path => "ubuntu/update-dns.sh"
	end
  end


  # Provision Worker Nodes
  (1..NUM_WORKER_NODE).each do |i|
   config.vm.define "kubenode0#{i}" do |node|
        node.vm.provider "virtualbox" do |vb|
            vb.name = "kubenode0#{i}"
            vb.memory = 2048
            vb.cpus = 2
        end
        node.vm.hostname = "kubenode0#{i}"
        node.vm.network :private_network, ip: IP_NW + "#{NODE_IP_START + i}"
                node.vm.network "forwarded_port", guest: 22, host: "#{2720 + i}"

        node.vm.provision "setup-hosts", :type => "shell", :path => "ubuntu/vagrant/setup-hosts.sh" do |s|
          s.args = ["enp0s8"]
        end
        node.vm.provision "setup-container-runtime", type: "shell", :path => "ubuntu/install-docker.sh"
        node.vm.provision "setup-dns", type: "shell", :path => "ubuntu/update-dns.sh"
    end
  end
end
