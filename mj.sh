#!/bin/bash

original_dir=$(pwd)
echo "Checking and installing necessary packages for Maven and Jenkins. This may take sometimes..."
# Update and upgrade packages
sudo yum update  &> /dev/null
sudo yum install wget &> /dev/null


# Install OpenJDK 17
# Check if Java 17 or above is already installed
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
REQUIRED_VERSION="17"

if [[ "$JAVA_VERSION" < "$REQUIRED_VERSION" ]]; then
    echo "Java version is below $REQUIRED_VERSION. Installing OpenJDK 17..."
    sudo yum install openjdk-17-jdk -y  &> /dev/null
else
    echo "Java version $JAVA_VERSION is already installed."
fi

# Set Java 17 as the default version
sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java  &> /dev/null

# Download and extract Apache Maven
wget https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz  &> /dev/null
sudo tar xf apache-maven-3.9.6-bin.tar.gz -C /opt  &> /dev/null

# Create a symbolic link for Maven
sudo ln -s /opt/apache-maven-3.9.6 /opt/maven  &> /dev/null
sudo ln -s /opt/maven/bin/mvn /usr/local/bin/mvn &> /dev/null

# Configure environment variables
sudo cp "$original_dir/setting_up_env_var" /etc/profile.d/maven.sh 

# Make the script executable
sudo chmod +x /etc/profile.d/maven.sh

# Reload environment variables
source /etc/profile.d/maven.sh

echo ""
echo ""
# Verify Maven installation
mvn -version
echo ""
echo ""
echo ""
echo ""





sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key  &> /dev/null
sudo yum upgrade  &> /dev/null
# Add required dependencies for the jenkins package
sudo yum install fontconfig java-17-openjdk  &> /dev/null
sudo yum install jenkins  &> /dev/null
sudo systemctl daemon-reload  &> /dev/null
# Check Jenkins service status
systemctl status jenkins
