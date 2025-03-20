# Additional Notes on Docker

Virtualization software for developing and deploying applications. "Packages" applications into a standardized unit (container), which contains everything it needs to run. Easily shared and distributed.

- Application code
- Libraries
- Dependencies
- Databases
- Configurations
- System tools
- Runtime

## VM vs Docker

Operating systems have 2 main layers:

- OS kernel: Core of every OS. Communicates with hardware components to allocate resources to the applications (memory, CPU, storage).
- OS applications layer

Docker virtualizates the applications layer and does not have its own kernel (uses the host's kernel).

A virtual machine has its own kernel and applications layer (virtualizes complete OS).

Docker images are much smaller than VM images, so we save a lot of disk space, and are faster to start. VM is compatible with all OSs, and Docker is only directly compatible with Linux distributions.

Docker was originally built for Linux and most containers are Linux-based. However, Docker eventually developed **Docker Desktop**, which allows Docker images to be run on other OSs like Mac and Windows. Uses a hypervisor layer with a lightweight Linux distribution to provide Linux kernel.

## Installing Docker

Go to official Docker website and follow latest installation steps for Docker Desktop (it often gets updated)

Docker Desktop includes:

- Docker Engine
- Docker CLI
- GUI Client (alternative to command line)

## Docker Images vs Containers

An **image** is an executable application artifact that includes app source code and complete environment configuration (environment variables, directories, files, etc.). It is an immutable template that defines how a container will be realized.

A **container** actually starts the application. It is a running instance of the image. You can run multiple containers from one image.

- docker images <-- check what images are available locally
- docker ps <-- lists running containers

## Docker Registry

How do we get images? There are docker registries available that are a storage and distribution system for docker images.

Official images are available from applications like Redis, Mongo, Postgres, etc.

Official images are maintained by the software authors or in collaboration with the Docker community.

Docker itself hosts the largest Docker registry, **Docker Hub.**

Docker images are versioned; as technology is updated, new images are created. Different versions are identified by tags.