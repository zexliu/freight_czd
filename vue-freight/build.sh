#!/usr/bin/env bash

yarn build

docker build -t zexliu/freight_admin:latest .

docker push zexliu/freight_admin:latest

#docker run -it -p 8099:80 cms-web:latest

