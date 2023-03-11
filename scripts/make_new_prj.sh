#!/usr/bin/env bash

if [ "$#" -lt 1 ]; then
  echo "==> Please provide the project folder"
  exit 1
fi


mkdir -p $1;dir_path=`echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"`

repo_root=`git rev-parse --show-toplevel`

echo " "
echo "===> Repo-Root = $repo_root"
echo " "

set -x

cp -f $repo_root/HelloWorld/build.sbt $dir_path; 
cp -f $repo_root/HelloWorld/.scalafix.conf $dir_path;

cp -f $repo_root/HelloWorld/.scalafmt.conf $dir_path
cp -f $repo_root/HelloWorld/scalastyle-config.xml $dir_path

mkdir -p $dir_path/project
cp -f $repo_root/HelloWorld/project/build.properties $dir_path/project
cp -f $repo_root/HelloWorld/project/plugins.sbt $dir_path/project


mkdir -p $dir_path/src/spinal
mkdir -p $dir_path/src/verilog
mkdir -p $dir_path/src/main/resources

cp -f $repo_root/HelloWorld/src/main/resources/log4j2.xml $dir_path/src/main/resources


mkdir -p $dir_path/test/spinal
mkdir -p $dir_path/test/verilog


mkdir -p $dir_path/test/cocotb/verilator/tb
mkdir -p $dir_path/test/cocotb/questa/tb

cp -f $repo_root/HelloWorld/test/cocotb/questa/tox.ini $dir_path/test/cocotb/questa
cp -f $repo_root/HelloWorld/test/cocotb/questa/conftest.py $dir_path/test/cocotb/questa

cp -f $repo_root/HelloWorld/test/cocotb/verilator/tox.ini $dir_path/test/cocotb/verilator


