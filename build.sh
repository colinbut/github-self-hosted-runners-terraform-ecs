#!/bin/bash
#docker build -t github-runner $(for i in `cat build.args`; do out+="--build-arg $i " ; done; echo $out;out="") .
docker build -t github-runner .
