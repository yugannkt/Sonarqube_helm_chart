#!/bin/bash
# Variables
SONAR_HOST="http://localhost:9000"
SONARQUBE_PORT=9000
SONARQUBE_DEFAULT_PASSWORD="admin"
SONARQUBE_NEW_PASSWORD="Qwerty@12345"
SONARQUBE_ADMIN_LOGIN="admin"
RETRY_DELAY=7
echo "Starting SonarQube container..."
echo "SonarQube is loading......"
# Function to wait for SonarQube to be reachable
sleep 120
wait_for_sonarqube() {
    echo "Waiting for SonarQube to be reachable at ${SONAR_HOST}..."
    while true; do
        # Check if SonarQube is reachable on the specified port
        nc -zv localhost $SONARQUBE_PORT
        if [ $? -eq 0 ]; then
            echo "SonarQube is reachable!"
            return 0
        else
            echo "SonarQube is not yet reachable. Retrying in $RETRY_DELAY seconds..."
            sleep $RETRY_DELAY
        fi
    done
}
# Function to check if SonarQube is healthy
check_sonarqube_health() {
    echo "Checking if SonarQube is healthy..."
    while true; do
        response=$(curl -s -o /dev/null -w "%{http_code}" -u "$SONARQUBE_ADMIN_LOGIN:$SONARQUBE_DEFAULT_PASSWORD" \
        "$SONAR_HOST/api/system/health")
        if [ "$response" -eq 200 ]; then
            echo "SonarQube is healthy."
            return 0
        else
            echo "SonarQube is not healthy. Retrying in $RETRY_DELAY seconds..."
            sleep $RETRY_DELAY
        fi
    done
}
# Function to change the default admin password
change_admin_password() {
    echo "Changing default SonarQube admin password..."
    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
        -u "$SONARQUBE_ADMIN_LOGIN:$SONARQUBE_DEFAULT_PASSWORD" \
        --data "login=$SONARQUBE_ADMIN_LOGIN&previousPassword=$SONARQUBE_DEFAULT_PASSWORD&password=$SONARQUBE_NEW_PASSWORD" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        "$SONAR_HOST/api/users/change_password")
    if [ "$response" -eq 200 ] || [ "$response" -eq 204 ]; then
        echo "Password changed successfully!"
    else
        echo "Failed to change the password. HTTP Status: $response"
        exit 1
    fi
}
# Main script execution
# Wait for SonarQube to be reachable
wait_for_sonarqube
# Check SonarQube health
check_sonarqube_health
# Change the admin password
change_admin_password