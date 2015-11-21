# docker-graphite-stresser

A simple docker container for automated stress testing of a graphite server using 
[graphite-stresser](https://github.com/feangulo/graphite-stresser.git)

----------------
## Contents

[1. Environment Variables](#environment-variables)

[2. Stress testing walkthrough](#stress-testing-walkthrough)

[3. Cleaning up](#cleaning-up)

## Environment variables
    GRAPHITE_STRESSER_HOST: The graphite server host to target
    GRAPHITE_STRESSER_PORT: The graphite server port to target
    GRAPHITE_STRESSER_NUMHOSTS: The number of hosts to simulate sending data from
    GRAPHITE_STRESSER_NUMTIMERS: The number of timers to create 
    # Possible timers values are 1, 2, 3, 4, 5, 10, 20, 64, 128, 256, 384, 650, 975, 1956, 3912, 4887, 7824, 9780, 13699]
    GRAPHITE_STRESSER_INTERVAL: The metric publishing interval
    GRAPHITE_STRESSER_DEBUG: True/false to enable or disable debug mode
    GRAPHITE_STRESSER_LOGFILE: Optional logfile to send output to

## Stress testing walkthrough

Metrics are published 15 at a time so for each publishing interval we will send

	published_metrics_rate = timers * 15
	published_metrics_per_minute = published_metrics_rate * (60/interval)
	
We then can plan a test set of messages and test the graphite server response

for example, below shows a run on the same host as a graphite server. The below settings are the same as the default ones.

	# 11K metrics per min
	docker run --net=host -it --name graphite-stresser \
    -e GRAPHITE_STRESSER_PORT=2003 \
    -e GRAPHITE_STRESSER_NUMHOSTS=1 \
    -e GRAPHITE_STRESSER_NUMTIMERS=128 \
    -e GRAPHITE_STRESSER_INTERVAL=10 \
    registry.service.dsd.io/platforms/graphite-stresser 

## Cleaning up

All the stress testers metrics are stored under the the key ``Graphite.STRESS`` and directory ``/graphite/whisper/STRESS``

