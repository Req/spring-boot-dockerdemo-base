# Docker

- Not part of the core curriculum
    - Still relevant to know for modern software/web development

- My experience
    - Many of my real projects in the past 10 years were dockerized
        - Elasticsearch, DBs, PHP, Ruby, Java/Spring boot, BPMSs...

## The problem

- "It works on my machine"
    - I have a different Database Engine version than you!
    - I have a different OS than you!
    - My [program_name] settings are different than yours!
    - Production uses a different OS than devs!
    - You built the thing with different environment variables!

- "Massive scaling is hard! Production updates are hard!"
    - Both still are hard, but docker can help

- Imagine a typical application in development
    - PostgreSQL database
    - Java core app
    - Keycloak service for user accounts
    - Elasticsearch search engine
    - Mobile frontend
    - Web frontend

- 50 devs with Linux & Mac and testing and a production too
    - Setting up identical environments... painful

## The solution

- You could dockerize the application!
    - Also called containerization
    - "Dockerizing" is packaging the application into container(s)
    - The containers would encapsulate _everything_ needed perfectly
    - Specific dependencies, specific versions, specific config, specific OS
    - Each environment is identical

    - There's even a virtual network, so the containers can talk
        - Naturally you can access them too!
        - Maybe the Java app is running in an Ubuntu container
        - Maybe the PSQL is running in an CentOS container

- A container is like a mini virtual machine
    - That don't need the resources of a fully blown virtual machine
    - Containers utilize existing kernel features to _partially_ virtualize
    - Traditional VMs have a full operating system is created for each VM
    - Docker also has filesystem and container image caching
        - Making Docker much faster than traditional VMs

- Sometimes only the development environment is containerized
- Sometimes dev and production
    - You can copy a container you are working on into a file
    - That file can be then duplicated as is to other developers
    - That file can be then duplicated as is to production
    - Completely identical software running everywhere

## How do you docker?

- You make containers based on existing containers
    - You have the base Ubuntu docker image
    - You have the base CentOS docker image
    - You have the base Alpine docker image

    - You can explore existing ones
        - https://hub.docker.com
            - Wordpress 1B+
            - MongoDB 1B+
            - MySQL 1B+
            - PostgreSQL 1B+
            - Ubuntu 1B+
            - Alpine 1B+
            - https://hub.docker.com/search?q=alpine&image_filter=official
    - You can make your own container out of that!

- Let's install docker and then try it out
    - `sudo docker run hello-world`

```sh
# Pull (=download) an image
$ sudo docker pull jboss/jbpm-server-full
$ sudo docker images  # List all Docker images in your system
$ sudo docker ps      # Show currently running containers (processes)

# Start a container based on an image: explain -p and -d flags later (not yet)
$ sudo docker run -p 8080:8080 -p 8001:8001 -d --name jbpm-server-full jboss/jbpm-server-full:latest
$ sudo docker ps      # Show currently running containers$ sudo docker ps      # Show currently running containers

# Demo Extra commands
$ sudo docker logs jbpm-server-full     # Show logs for container
$ sudo docker logs -f jbpm-server-full  # Show logs for container (-f for follow), ^C to stop
$ sudo docker stop jbpm-server-full     # Stop a running container
$ sudo docker ps -a                     # Show all containers (including stopped ones)
$ sudo docker rm <container-id>         # Remove container
$ sudo docker images                    # Show/list all images
$ sudo docker rmi <image-id>            # Remove image
```

- You can have multiple containers made from the same Image!
    - Java analogy
        - Image = Class             `class JbossJbpmServerFull {}`
        - Container = Instance      `var jbpm-server-full = new JbossJbpmServerFull()`

### Let's create a mini Dockerfile and an image

- Docker images are created from a "Dockerfile"
    - Just a file called "Dockerfile" in the root of your project
    - [Like this one](Dockerfile)

- Mini dockerfile:

    ```dockerfile
    FROM alpine:latest

    CMD ["echo", "Docker is EZ"]
    ```


- Building an _image_ based on a Dockerfile in the current directory:

    ```sh
        # Search current folder (./) for Dockerfile build a docker image based on that
        # Give the created image the name "testthing"
        $ docker build -t testthing .

        # Create and start a container from the image
        $ docker run testthing

        # Container starts and exists immediately because it's dumb and only does echo "asddasasd"
    ```

## Let's expand on the previous and containerize Spring Boot

- 1. Prepare Dockerfile for our project
- 2. Create docker image based on Dockerfile
- 3. Run container based on image

- Final Dockerfile at [here](Dockerfile)
- Commands used

```sh
# Build a docker image from the current folder (.) - this reads the Dockerfile
$ sudo docker build . -t some-thingy
# Start a container based on the image, exposes port 49160 on the host machine to port 7777 in container
# Normally 8080 on both
# -d is to run in detached mode
$ sudo docker run -p 49160:7777 -d some-thingy  
$ sudo docker ps                                    # List running docker containers
$ sudo docker logs <container-id>                   # View logs for running container
$ sudo docker exec -it <container-id> /bin/bash     # Open shell in running container
```

- Note how I didn't actually talk about how to develop
    - The workflow where you can run your code in Docker
    - And still use VSCode/IntelliJ like with a normal folder setup
    - Yeah it can get a little complicated

- Most projects need multiple dockers
    - SQL, Spring Boot, elasticsearch
    - They need to all start with one command and set up connections between
    - This "orchestration" is done often with `docker-compose`
    - That is outside the scope of this workshop

- BIG projects that run containers in production
    - Can have thousands of containers
    - This swarm of containers might be managed with `Kubernetes`
    - Kubernetes = orchestration of large container environments
        - Creates containers (servers) on demand
        - Destroys containers (servers) on demand
        - Updates containers (servers) on demand
        - Updates container configs
        - Can be _stupidly_ complex if you ask me

- Our containerized app is running out of resources?
    - Out of RAM? Dynamically add RAM
    - Out of CPU? Create new containers to load balance
    - http://tiven.wang/images/cloud/kubernetes/Kubernetes-cluster-kubeadm-arc.png
    - https://www.virtuozzo.com/company/blog/scaling-kubernetes/
    - It's not unusual to have MANY containers
    - The practical configuration of this is hard
