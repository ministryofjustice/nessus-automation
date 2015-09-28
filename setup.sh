#! /bin/bash

boot2docker start
$(boot2docker shellinit)

docker images | grep sometheycallme/docker-nessus

if docker images | grep sometheycallme/docker-nessus; then 
  docker pull sometheycallme/docker-nessus
fi

docker run -d --name nessusd -p 8834:8834 sometheycallme/docker-nessus

IP=$(boot2docker ip)

open "https://$IP:8834/"