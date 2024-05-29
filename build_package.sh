#!/usr/bin/env sh

cd docker

./dockerctl.sh -rm

./dockerctl.sh -b $@

./dockerctl.sh -c $@
