# Docker Networking

Docker CLI allows you to run commands like docker run, docker build, docker pull, and that communicates with the docker daemon, which specifies an image as the starting point to create a container. If the image isn't local, it may pull an image from an external api.

Docker containers are a temporary filesystem layered over an image that are fully writable (copy on write) and disappears at the end of life. They also provide a network stack and consist of a process group (one main process with possible subprocesses).

What networking is set up in docker?

## Docker Network Namespaces

You cannot see network namespaces created by docker by running ip netns list because docker doesn't create a reference of the namespace file in the /var//run/netns directory. It does indeed create a new network namespace, though. 

To see the namespace, do the following:

- docker inspect <containername> shows you information about the container, but most importantly, you can get the process id under "State" -> "Pid"

ls /proc/<pid>/ns/net

run sudo mount -o bind /proc/<pid>/ns/net /var/run/netns/<containername> <-- mounts the directory to your /var/run/netns folder

Now, you will be able to run ip netns and see the network namespace the docker created.

And now you can run commands with sudo ip netns exec <containername> <command>

## Custom Networks in Docker

docker0 is a default network bridge that all container attach to (unless otherwise specified)

You can create your own network (a bridge other than docker0 connecting to containers)

- docker network create --help
- docker network create mynet1 (gives a default subnet)
- docker network create --subnet-11.11.11.0/24 mynet

- docker run --net=mynet1 --name cont3 -dit myimg <-- runs a container on your custom network (defaults to docker0 if not specified)
- docker exec cont3 ifconfig

You can also attach containers to multiple networks

- docker network connect [options] <network> <container>
- docker network connect cont3 docker0

## Port Forwarding

Docker supports port forwarding

- docker run -p <host_port>:<container_port> <image>
- docker run --name cont2 -p 8080:80 -dit myimg

## Docker Compose Wrapper

What is it:

- YAML wrapper for docker commands (build, pull, run, etc.)
- Also supports multiple containers
- To install: https://docs.docker.com/compose/install/
- To use: https://docs.docker.com/compose/reference/

docker-compose --help (build, run, a lot of the same commands)