FROM amazonlinux:2

# Remove old curl-minimal and maven, install required tools
RUN yum remove -y curl-minimal maven && \
    yum install -y curl java-17-amazon-corretto git unzip wget tar && \
    yum clean all

# Install Maven 3.8.8 manually
RUN wget https://downloads.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz && \
    tar -xzf apache-maven-3.8.8-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.8.8 /opt/maven && \
    rm apache-maven-3.8.8-bin.tar.gz

ENV MAVEN_HOME=/opt/maven
ENV PATH=${MAVEN_HOME}/bin:${PATH}

# Verify Maven version (optional)
RUN mvn -version

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
CMD ["sh", "/mnt/project/apache-tomcat-9.0.108/bin/catalina.sh", "run"]
