#!/usr/bin/python3

import docker
import time
import sdnotify

notifier = sdnotify.SystemdNotifier()

client = docker.from_env()

notifier.notify('READY=1')

while True:
    notifier.notify('STATUS=Watching containers')
    health_states = {}

    for container in client.containers.list():
        container_state = container.attrs['State']
        if 'Health' in container_state:
            health_state = container_state['Health']['Status']
            if health_state == 'unhealthy':
                message = f'Container "{container.name}" unhealthy. Restarting.'
                notifier.notify(f'STATUS={message}')
                container.restart()

    time.sleep(60)
