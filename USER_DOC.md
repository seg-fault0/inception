# User Documentation

This document provides a simple guide to understanding, operating, and managing the services provided by this web stack.

## 1. Services Provided by the Stack
This project runs a containerized web infrastructure. It automatically sets up and connects the following services:
* **Web Server (Nginx):** Handles incoming secure web traffic (HTTPS) and routes it to the application.
* **Application (WordPress):** The content management system (CMS) used to build and manage the website. 
* **Database (MariaDB/MySQL):** Stores all the website's data, including users, posts, and configuration settings.

## 2. Starting and Stopping the Project
The project uses Docker Compose to manage the services. Open your terminal in the root directory of the project (where the `docker-compose.yml` file is located) and run the following commands:

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

## 3. Accessing the Website and Administration Panel
Once the services are up and running, you can access the application through your web browser:

* **Main Website:** 
  Navigate to `https://localhost` (or `https://your-domain.com` / `https://localhost:9000` depending on your specific domain configuration).
* **Administration Panel:** 
  Navigate to `https://localhost/wp-admin`. 
  Here, you will be prompted to enter your administrator username and password to manage the site content.

## 4. Locating and Managing Credentials
For security reasons, passwords and sensitive configuration details are not hardcoded into the project files. They are managed using a combination of environment variables and Docker secrets:

* **Environment Variables (`.env`):** General configuration settings are stored in a `.env` file, which must be placed inside the `srcs/` directory.
* **Passwords (`secrets/`):** All sensitive passwords (such as database passwords and WordPress admin details) are stored securely inside the `secrets/` directory.
* **How to manage them:** 
  * Open the `srcs/.env` file with any text editor to modify environment settings.
  * Open the specific credential files inside the `secrets/` directory (e.g., `db_password`) to view or modify passwords.
  * *Note: If you change database credentials after the project has already run for the first time, you may need to reset your database volume for the new credentials to take effect.*
* **Security:** Never share your `.env` file or the contents of your `secrets/` directory, and never upload them to a public repository like GitHub. 

## 5. Checking that the Services are Running Correctly
If you are experiencing issues or just want to verify the stack's health, use the following terminal commands:

* **Check container status:**
  ```bash
  docker compose ps
  ```
  *Look under the "STATUS" column. You should see "Up" for your database, application, and web server containers. If a container says "Restarting" or "Exited", there is an issue.*

* **View service logs:**
  To see exactly what is happening inside the containers and spot any errors, run:
  ```bash
  docker compose logs
  ```
  *(Add `-f` to the end of the command to follow the logs live: `docker compose logs -f`)*