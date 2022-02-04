#!/bin/bash

docker pull ubuntu
docker rm -f $(docker ps -a -q)
docker run -p 30889:30889 -v /home/developer:/home/developer --cap-add=SYS_PTRACE --privileged --shm-size 1g --device=/dev/kvm -itd ubuntu
docker start $(docker ps -a -q)
docker attach $(docker ps -a -q)
