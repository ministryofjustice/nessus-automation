#! /bin/bash

boot2docker start
$(boot2docker shellinit)

if [ -z "$(docker images | grep sometheycallme/docker-nessus)" ]; then 
  docker pull sometheycallme/docker-nessus
fi

if [ -z "$(docker ps | grep nessusd)" ]; then 
  docker run -d --name nessusd -p 8834:8834 sometheycallme/docker-nessus
fi

IP=$(boot2docker ip)

open "https://$IP:8834/"