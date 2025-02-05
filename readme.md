# SonarQube Docker Setup
This repository provides a Docker setup for SonarQube with a custom script to automatically configure the admin password upon startup.

## Overview
    Dockerfile: Uses the official SonarQube image as the base and installs necessary dependencies. It copies a custom setup script that modifies the default admin password.
    
    Custom Setup Script: The script waits for SonarQube to be reachable, checks if it's healthy, and then updates the default admin password.
    
    Entrypoint: The custom entrypoint runs the SonarQube entrypoint script in the background, executes the setup script, and keeps the container running.
      
## Build the Docker Image
Clone the repository and build the Docker image:
```
docker build -t <your-image-name> .
```

## Push to Azure Container Registry (ACR)
Tag the Docker image with your ACR repository name and push it:
```
docker tag <your-image-name> <your-acr-name>.azurecr.io/<your-image-name>:<tag>

docker push <your-acr-name>.azurecr.io/<your-image-name>:<tag>
```
## Running the Container
Run the Docker container to start SonarQube:
```
docker run -d -p 9000:9000 --name sonarqube-repository <your-image-name>
```
The setup script will automatically wait for SonarQube to be fully up and running, check its health, and change the default admin password.
