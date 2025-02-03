# Use the official SonarQube image as the base image
FROM sonarqube:latest
# Set the working directory
WORKDIR /opt/sonarqube
# Copy the custom setup script into the container
COPY sonar_setup.sh /opt/sonarqube/sonar_setup.sh
# Switch to root user to modify file permissions
USER root
# Grant execute permission to the setup script
RUN chmod +x /opt/sonarqube/sonar_setup.sh
# Install curl and netcat (netcat-openbsd variant)
RUN apt-get update && apt-get install -y curl netcat-openbsd
# Switch to the 'sonarqube' user to avoid running as root
USER sonarqube
# Set the entrypoint to run the setup script on container startup
ENTRYPOINT ["/bin/bash", "-c", "/opt/sonarqube/docker/entrypoint.sh & /opt/sonarqube/sonar_setup.sh && tail -f /dev/null"]
# Expose the SonarQube port
EXPOSE 9000