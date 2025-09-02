FROM amazonlinux:2023

# Install Java 17, Maven, Git, curl, unzip
RUN dnf install -y java-17-amazon-corretto maven git curl unzip

# Set working directory
WORKDIR /mnt/project

# Clone the WAR repo
RUN git clone https://github.com/praveenakumara/war-application.git

# Build WAR
WORKDIR /mnt/project/war-application
RUN mvn clean package

# Download Tomcat
WORKDIR /mnt/project
RUN curl -O https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.108/bin/apache-tomcat-9.0.108.zip && \
    unzip apache-tomcat-9.0.108.zip && \
    rm apache-tomcat-9.0.108.zip

# Copy WAR to Tomcat webapps
RUN cp /mnt/project/war-application/target/*.war /mnt/project/apache-tomcat-9.0.108/webapps/babaji.war

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["sh", "/mnt/project/apache-tomcat-9.0.108/bin/catalina.sh", "run"
