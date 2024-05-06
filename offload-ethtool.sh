#!/bin/sh
ssh root@192.168.0.123 "ethtool -K eno1 gso off gro off tso off tx off rx off rxvlan off txvlan off sg off"
