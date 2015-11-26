# docker-graphite-stresser

A simple docker container for automated stress testing of a graphite server using 
[graphite-stresser](https://github.com/feangulo/graphite-stresser.git) for scheduled mode loading and
[haggar](https://github.com/gorsuch/haggar.git) for accumulation mode loading


----------------
## Contents

[1. Setting the mode](#setting-the-mode)

[2. Environment Variables](#environment-variables)

[3. Default settings](#default-settings)

[4. Stress testing walkthrough](#stress-testing-walkthrough)

[5. Cleaning up](#cleaning-up)

## Setting the mode

One mode must be chosen by setting either the scheduled mode, where a set of metrics is generated at
set intervals and sent to the graphite server

	# SCHEDULED MODE
	GRAPHITE_STRESSER_MODE=scheduled
	
or the 'accumulate' mode, which gradually increases the number of agents sending metrics until the
server is brought down.
	
	# ACCUMULATION MODE
	GRAPHITE_STRESSER_MODE=accumulate
			
## Environment variables

There are 2 sets of environment variables, one set is applicable in both modes, the accumulation
mode only ones are relevant only in that mode.

	# BOTH SCHEDULED AND ACCUMULATION MODE
    GRAPHITE_STRESSER_HOST: The graphite server host to target
    GRAPHITE_STRESSER_PORT: The graphite server port to target
    GRAPHITE_STRESSER_NUMHOSTS: The number of hosts to simulate sending data from
    GRAPHITE_STRESSER_NUMTIMERS: The number of timers to create 
    # Possible timers values are 1, 2, 3, 4, 5, 10, 20, 64, 128, 256, 384, 650, 975, 1956, 3912, 4887, 7824, 9780, 13699]
    GRAPHITE_STRESSER_INTERVAL: The metric publishing interval
    GRAPHITE_STRESSER_DEBUG: True/false to enable or disable debug mode
    GRAPHITE_STRESSER_LOGFILE: Optional logfile to send output to

	# ACCUMULATION MODE
	GRAPHITE_STRESSER_METRICS: The number of metrics for each agent to send
	GRAPHITE_STRESSER_ACCUMULATION_INTERVAL: The interval to increase the agent count
	GRAPHITE_STRESSER_JITTER: The jitter in metrics sent
    GRAPHITE_STRESSER_AGENTS: The number of accumulation agents to run concurrently

## Default Settings

	    GRAPHITE_STRESSER_HOST=localhost   
	    GRAPHITE_STRESSER_PORT=2003 
	    GRAPHITE_STRESSER_NUMHOSTS=1   
	    GRAPHITE_STRESSER_NUMTIMERS=128   
	    GRAPHITE_STRESSER_INTERVAL=10  
	    GRAPHITE_STRESSER_DEBUG=false 
	    GRAPHITE_STRESSER_METRICS=10000
	    GRAPHITE_STRESSER_ACCUMULATION_INTERVAL=10
	    GRAPHITE_STRESSER_JITTER=10
	    GRAPHITE_STRESSER_AGENTS=100   
	    
## Stress testing walkthrough

Metrics are published 15 at a time so for each publishing interval we will send

	published_metrics_rate = timers * 15
	published_metrics_per_minute = published_metrics_rate * (60/interval)
	
We then can plan a test set of messages and test the graphite server response

for example, below shows a run using the scheduled mode.

	docker run --net=host -it --name graphite-stresser -e GRAPHITE_STRESSER_MODE=scheduled -e GRAPHITE_STRESSER_NUMTIMERS=128 registry.service.dsd.io/platforms/graphite-stresser:latest 

and for accumulation mode

	docker run --net=host -it --name graphite-stresser -e GRAPHITE_STRESSER_MODE=accumulate registry.service.dsd.io/platforms/graphite-stresser:latest 

## Cleaning up

All the stress testers metrics are stored under the the keys ``Graphite.STRESS`` and ``Graphite.STRESS_ACCUMULATE`` and directories ``/graphite/whisper/STRESS`` and ``/graphite/whisper/STRESS_ACCUMULATE``

