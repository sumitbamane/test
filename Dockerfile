# Use official Tomcat image
FROM tomcat:9.0.62-jdk11

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file as ROOT.war (this is crucial!)
COPY app.war /usr/local/tomcat/webapps/ROOT.war

# Explicitly extract WAR to ensure deployment
RUN cd /usr/local/tomcat/webapps && \
    unzip ROOT.war -d ROOT/ && \
    chown -R root:root ROOT/

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
