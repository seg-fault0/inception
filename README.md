*This project has been created as part of the 42 curriculum by wimam.*

## Description

**Inception** is a system administration and infrastructure project that challenges us to deploy a complete, containerized web architecture from scratch. The primary goal is to broaden our understanding of system administration by strictly using Docker to isolate and manage services. 

### Use of Docker and Included Sources
We use Docker so our project works exactly the same way on any computer. It keeps everything isolated and clean. 

The files included in this project are:
*   **docker-compose.yml:** The main file that connects all the containers and starts them together.
*   **Makefile:** A file with simple command shortcuts to start, stop, and clean up the project.
*   **Dockerfiles:** The step-by-step instructions on how to build each specific container (Nginx, WordPress, MariaDB).
*   **Config files:** Settings for the servers and setup scripts that run when the containers start.

### Main Design Choices
*   **Base System:** Every container is built using Debian Linux because it is reliable and easy to work with.
*   **One Job Per Container:** The database, the web server, and the website never share a container. They are completely separate.
*   **Security:** Nginx is the only open door. It handles secure connections (HTTPS) and safely passes traffic to the WordPress site hidden on the inside network.

### Comparisons

*   **Virtual Machines vs Docker:** 
    Virtual Machines use a hypervisor to virtualize entire hardware stacks, meaning each VM runs its own heavy, complete guest operating system. Docker, conversely, uses OS-level virtualization. Containers share the host system's kernel, making them remarkably lightweight, faster to boot, and less resource-intensive.

*   **Secrets vs Environment Variables:** 
    Environment variables (`.env` files) are standard for passing configuration data, but they are stored in plain text and can be viewed by anyone with access to the host via `docker inspect`. Docker Secrets provide a highly secure alternative (typically used in Docker Swarm); they are encrypted, transmitted securely, and mounted directly into the container's temporary memory (`tmpfs`), meaning they never persist on the disk.

*   **Docker Network vs Host Network:** 
    A Docker network (like a `bridge`) creates an isolated, internal virtual network for containers to communicate with each other securely using DNS resolution, completely shielding them from the outside world unless specific ports are published. A Host network bypasses this isolation entirely, attaching the container directly to the host machine's networking stack, meaning it shares the host's IP and port space.

*   **Docker Volumes vs Bind Mounts:** 
    Volumes are managed entirely by Docker and live in a protected area of the host filesystem (e.g., `/var/lib/docker/volumes/`). They are isolated, easier to back up, and persist even if the container is destroyed. Bind Mounts map a specific, absolute file path from the host machine directly into the container. While convenient for active development, bind mounts are heavily dependent on the host's directory structure and permission settings.

## Instructions

### What You Need
*   A Linux computer (like Debian).
*   `docker` and `docker-compose` installed.
*   `make` installed.

### Setup
Before starting, you need to point the website address to your own computer.
1. Open your host file: `sudo nano /etc/hosts`
2. Add this line at the bottom:
   `127.0.0.1 wimam.42.fr`

### How to Run It
Use the `Makefile` commands to control the project:

*   **Build and start everything:**
    ```bash
    make
    ```
*   **Stop the project safely:**
    ```bash
    make down
    ```
*   **Stop and delete all containers, networks, and data volumes:**
    ```bash
    make clean
    ```
*   **Delete absolutely everything (including all Docker images):**
    ```bash
    make fclean

Once running, the site is accessible via `https://wimam.42.fr`.

## Resources

**References & Documentation:**
*   [Docker Official Documentation](https://docs.docker.com/)
*   [Nginx Documentation](https://nginx.org/en/docs/)
*   [WordPress CLI (WP-CLI) Documentation](https://make.wordpress.org/cli/handbook/)
*   [MariaDB Server Documentation](https://mariadb.com/kb/en/documentation/)

**AI usage:**

AI was used as a learning assistant for understanding how the major concepts work (TLS, docker, Linux namespaces, databases, reverse proxy ...)