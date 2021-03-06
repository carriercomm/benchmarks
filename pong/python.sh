#!/bin/bash -x

d=$(readlink -f $(dirname $0))

spawn-fcgi -p 9000 -n -- $d/python.py &
py=$!

sleep 1

sudo /usr/local/nginx/sbin/nginx -c $d/python.nginx.conf &
nx=$!

sleep 1

httperf --hog --server=localhost --port=3000 --uri=/ --rate=1000 --num-conns=200 --num-calls=100 --burst-length=20 > results/python
sudo kill $nx
kill $py
