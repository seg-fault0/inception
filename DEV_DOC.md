# Developer Documentation

This document outlines the technical architecture and provides instructions for developers to set up, build, manage, and troubleshoot the containerized Nginx, WordPress, and MariaDB stack.

## 1. Setting Up the Environment from Scratch

### Prerequisites
Before starting, ensure the host machine (e.g., Debian/Ubuntu) has the following installed:
* **Docker** (Engine)
* **Docker Compose** 
* **Make** (for using the Makefile)

### Configuration Files and Secrets
The project relies on environment variables and file-based secrets to run securely. You must set these up before building the project.

1. **Environment Variables (`srcs/.env`):**
   Create a `.env` file inside the `srcs/` directory. This file holds non-sensitive configurations and environment variables required by Docker Compose.
   *Example `srcs/.env`:*
   ```ini
	MYSQL_DATABASE=wordpress

	MYSQL_USER=mduser

	WP_SUPER_USER=superwalid
	WP_USER=walid

	SUPER_USER_EMAIL=superUser@gmail.com
	USER_EMAIL=userEmail@gmail.com

	NGINX_PORT=443
	WP_PORT=9000
	MD_PORT=3306
   ```

2. **Secrets (`secrets/` directory):**
   Create a `secrets/` folder in the root of the project to store sensitive passwords. Docker Compose will read these files and inject them securely into the containers. 
   Create the following files and paste the corresponding plain-text passwords inside them:
   * `secrets/db_wp_user_pw`
   * `secrets/wp_admin_pw`
   * `secrets/wp_user_pw`
   
   *Warning: Ensure `srcs/.env` and the `secrets/` directory are added to your `.gitignore` to prevent leaking credentials.*

## 2. Building and Launching the Project

This project uses a `Makefile` to simplify Docker Compose commands. 

* **To build and launch the project:**
  ```bash
  make
  ```
  *(Or `make up` / `make all`, depending on your specific Makefile configuration). This will read the compose file, build the necessary Nginx, WordPress, and MariaDB images, and start the containers in detached mode.*

* **To stop the project:**
  ```bash
  make down
  ```

* **To perform a complete clean-up:**
  ```bash
  make fclean
  ```

* **To rebuild the project:**
  ```bash
  make re
  ```

## 3. Managing Containers and Volumes

While the Makefile handles standard operations, you will often need to use raw Docker commands for debugging and management:

### Container Management
* **List running containers:**
  ```bash
  docker compose ps
  ```
* **View logs for all services:**
  ```bash
  docker compose logs -f
  ```
* **View logs for a specific service:**
  ```bash
  docker compose logs -f <container_name>
  ```
* **Access a running container's shell:**
  To debug inside a container (e.g., the WordPress container):
  ```bash
  docker exec -it <container_name> /bin/bash
  ```

### Volume Management
* **List all Docker volumes:**
  ```bash
  docker volume ls
  ```
* **Inspect a specific volume:**
  ```bash
  docker volume inspect <volume_name>
  ```

## 4. Data Storage and Persistence

Because Docker containers are ephemeral (data inside them is lost when the container is removed), this project uses **Docker Volumes** to persist critical data.

### How it Works
The `docker-compose.yml` mounts specific directories from inside the containers to the host machine or to named Docker volumes. 

### Where Data is Stored

To guarantee data persistence, the directories inside the containers are mapped (bound) to specific directories on the host machine. 

* **Database Data (MariaDB):**
  * **Inside the container:** The database files are generated and stored in `/var/lib/mysql`.
  * **Outside the container (Host Machine):** This directory is mapped to a local path on your machine (commonly something like `/home/${USER}/data/mariadb` or a Docker named volume, depending on your `docker-compose.yml`). This ensures that user accounts, posts, and site configurations survive even if the MariaDB container is completely destroyed and recreated.

* **Web Files (WordPress):**
  * **Inside the container:** The WordPress core files, downloaded themes, plugins, and user-uploaded media are stored in `/var/www/html`.
  * **Outside the container (Host Machine):** This directory is mapped to a local path on your machine (commonly something like `/home/${USER}/data/wordpress` or a Docker named volume). 
  
  *Note: Mapping the WordPress directory to the host is critical not only for saving your site modifications, but also because the Nginx container needs to share this exact same volume to successfully find and serve your static web files.*