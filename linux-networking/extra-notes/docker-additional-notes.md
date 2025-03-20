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

## Pulling a Docker Image

- docker pull <image-name>:<tag> <-- pulls and downloads image locally from DockerHub. This is the default registry; you can specify other registries if desired.

If you don't specify a tag/version, it will automatically pull the latest verison.

## Running an Image

- docker run <image-name>:<tag> <-- starts container based on image
- docker run -d <image-name>:<tag> <-- starts container based on image <-- -d (--detach) runs container in background and prints container ID. This makes it so the terminal isn't blocked and you can run commands while container runs in the background

- docker logs <container-id> <-- view logs from service running inside the container

Docker pulls the image automatically if it doesn't find it locally; can skip the pull step

## Port Binding

How do we access containers? The application inside the container runs in an isolated Docker network.

We need to expose the container port to the host (the machine the container runs on).

**Port binding** binds the container's port to the host's port to make the service available to the outside world.

Each application has some standard port it runs on; you can find this with docker ps

- docker run -d -p <host-port>:<container-port> <image-name>:<tag> <-- -p (--publish) binds the container port to the host port. e.g. docker run -d -p 9000:80 nginx:1.23 (bind's host port 9000 to the container port nginx is running on, 80)

It is standard practice to choose the same port on your host that the container is using (example above would be 80:80).

Note that only one service can run on a specific port on the host.

## Starting and Stopping Containers

docker run creates a new container every time it is run; does not reuse previous container.

- docker ps -a (--all) <-- lists all containers, stopped and running
- docker stop <container-id> <-- stops running container
- docker start <container-id> <-- start one or more stopped containers

Instead of passing container id for these commands, you can specify a more meaningful name during container creation. Docker automatically generates a name if not specified.

- docker run --name web-app <image-name>

## Private Docker Registries

Whereas DockerHub is a public registry, many companies including major cloud providers (Amazon ECR, Google Container Registry, etc.) offer private registries. You must authenticate before accessing the registry. DockerHub also has a private registry and you can store your own private images there.

A **registry** is a service providing storage and can be hosted by a third party like AWS, yourself, etc., and can store multiple repositories. AKA a collection of repositories.

A **repository** is a collection of related images with the same name but different versions.

## Creating Your Own Images

You use a **Dockerfile** to create custom images for applications. The Dockerfile is a "definition" of how to build an image from our application. It is a text document that contains commands to assemble an image. Docker can then build an image by reading these instructions.

### Dockerfile Structure

In the root of your project directory, create a file called Dockerfile

Dockerfiles start from a parent image or "base image," which is a Docker image that your image is based on. You choose the base image depending on which tools you need to have available (such as Node for JavaScript applications, which has node and npm installed already).

- Dockerfiles must begin with FROM instruction; build this image from the specified image.

Essentially, we are mapping what we would need to do to run the application locally to the Dockerfile instructions (such as running npm install, etc.)

- RUN will execute any command in a shell inside the container environment

We also need to copy application files from host into the container

- COPY <-- copies files or directories from src and adds them to the filesystem of the container at the path dest

- We also need to set the working directory for all following commands. Equivalent of cd

- WORKDIR <directory>

The process that starts the application, the final directive of the Dockerfile, is denoted with CMD. There can only be one CMD instruction in a Dockerfile.

- CMD ["node", "server.js"]

### Building the Image from Dockerfile

- docker build <path> <-- builds a Docker image from a Dockerfile
- docker build -t (--tag) <image-name>:<tag> <path> <-- sets a name and optionally a tag in the name:tag format