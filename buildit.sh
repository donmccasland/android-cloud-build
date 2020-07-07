#!/bin/bash
PROJECT_ID=android-cloud-build-282019
REPODIR=/Users/donmccasland/Repos

docker build -t gcr.io/${PROJECT_ID}/android-build .
docker push gcr.io/${PROJECT_ID}/android-build

cd $REPODIR/iosched
docker run -it --entrypoint /bin/bash -v `pwd`:/home/app gcr.io/${PROJECT_ID}/android-builder:latest
