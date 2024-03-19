#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update \
  && apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     software-properties-common \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
  && add-apt-repository \
      "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" \
  && apt-get update \
  && apt-get install -y containerd.io \
  && echo 'success' > /tmp/checking