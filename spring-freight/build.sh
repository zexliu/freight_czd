#!/usr/bin/env bash

gradle build -x test

docker build -t zexliu/freight_api:latest .

docker push zexliu/freight_api:latest

