- #### First check status vagrant:
> vagrant status

- #### start host:
> vagrant up

- ##### install container  runtime: https://kubernetes.io/docs/setup/production-environment/container-runtimes/

- ##### install containerd
- ##### config containerd 
> path: /etc/containerd/config.toml

[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
   [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
SystemdCgroup = true

> sudo systemctl restart containerd

- ##### install kubeadm, kubelet, kubectl
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl

- ##### creating a new cluster (multiple master node)
> **_create only in master node_**: 
> kubeadm init --pod-network-cidr=10.244.0.0/16 \
> --cri-socket unix:///run/containerd/containerd.sock \
> --upload-certs --control-plane-endpoint=ip_loadbalancer:port_loadbalancer 

> kubeadm init --pod-network-cidr=10.244.0.0/16 \
> --cri-socket unix:///run/containerd/containerd.sock \
> --upload-certs --control-plane-endpoint=192.168.56.99:6443

- ##### creating a new cluster (one master node)
> sudo kubeadm init --apiserver-advertise-address=192.168.56.2 \ 
> --pod-network-cidr=10.244.0.0/16 \
> --cri-socket unix:///run/containerd/containerd.sock --upload-certs

run:
> mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

- ##### install cni
> curl -LO https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml

edit: kube-flannel.yml:
> `- --ip-masq`
>
> `- --kube-subnet-mgr`

addition: - --iface=enp0s8

> `- --iface=enp0s8`
> 
> `- --ip-masq`
> 
> `- --kube-subnet-mgr`


- ##### join a new Master Node => cluster
> kubeadm join 192.168.56.99:6443 --token o23rbr.ca69kaaofr6irw7c \
--discovery-token-ca-cert-hash sha256:29463223862b8c182d06015357eb557689fb2fe7cab23e72bad742dc737413ec \
--control-plane --certificate-key 006c13f7fc18c715342e3098c2ba2484ba22ba25407bd6075d4c98dba3de9283

- ##### join a new Worker Node => cluster
> kubeadm join 192.168.56.99:6443 --token o23rbr.ca69kaaofr6irw7c \
--discovery-token-ca-cert-hash sha256:29463223862b8c182d06015357eb557689fb2fe7cab23e72bad742dc737413ec

- ##### kubeadm list "token":
> kubeadm token list

- ##### create new "token":
> kubeadm token create

- ##### create new "discovery-token-ca-cert-hash":
> openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
> 
> openssl dgst -sha256 -hex | sed 's/^.* //'

- ##### upload "discovery-token-ca-cert-hash" => in SECRET "kubeadm-certs" in the "kube-system" namespace: 
> kubeadm init phase upload-certs --upload-certs