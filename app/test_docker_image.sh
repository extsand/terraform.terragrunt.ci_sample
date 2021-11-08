#!/bin/bash
echo "Test docker image"
echo $1
docker run -it -p 80:80 $1


