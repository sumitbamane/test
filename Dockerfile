# Use official Tomcat image with JDK
FROM tomcat:9.0-jdk17-openjdk

# Maintainer information
LABEL maintainer="your-email@example.com"
LABEL description="WAR Application Docker Container"

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file to Tomcat webapps directory
# The pipeline copies the WAR as "app.war" to the dockerfile directory
COPY app.war /usr/local/tomcat/webapps/ROOT.war

# Create application directory and set permissions
RUN mkdir -p /usr/local/tomcat/webapps/ROOT && \
    chown -R root:root /usr/local/tomcat/webapps/

# Expose port 8080
EXPOSE 8080

# Health check to verify application is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]
