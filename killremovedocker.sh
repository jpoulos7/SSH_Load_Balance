#!/bin/bash
echo "Stopping haproxy..."
service haproxy stop
echo "Stopping containers..."
docker stop $(docker ps -a -q)
sleep 2
echo "Removing containers..."
docker rm $(docker ps -a -q)
