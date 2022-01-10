#!/bin/bash
echo "Started building nginx and apache images."
docker build --tag my-nginx:latest ./data/nginx
docker build --tag my-apache:latest ./data/apache

#echo "Started creating nginx and apache containers."
#docker run -p 80:80 -d --rm --name my-nginx my-nginx:latest
#docker run -p 8081:80 -d --rm --name my-apache my-apache:latest
