FROM amazonlinux:2023

# Install Java 17, Maven, Git, curl, unzip
RUN dnf install java-17-amazon-corretto maven git curl unzip -y

# Set working directory
WORKDIR /mnt/project

# Clone your war-application repo
RUN git clone https://github.com/praveenakumara/war-application.git

# Build the WAR using Maven
RUN cd war-application && mvn clean package

# Download and extract Apache Tomcat 9.0.108
RUN curl -O https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.108/bin/apache-tomcat-9.0.108.zip && \
    unzip apache-tomcat-9.0.108.zip && \
    rm apache-tomcat-9.0.108.zip

# Copy WAR file to Tomcat webapps/
RUN cp war-application/target/*.war apache-tomcat-9.0.108/webapps/babaji.war

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["sh", "/mnt/project/apache-tomcat-9.0.108/bin/catalina.sh", "run"]

