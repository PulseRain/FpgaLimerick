#!/usr/bin/env bash

sudo ip link add vmnic0 type dummy

#setup the dummy mac address here
sudo ip link set vmnic0 addr 00:15:5d:7d:46:6a
