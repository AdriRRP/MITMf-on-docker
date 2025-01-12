#!/bin/bash
docker run --rm --privileged --network host --cap-add=NET_ADMIN --cap-add=NET_RAW -it mitmf-docker $@
