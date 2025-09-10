# Use the official Tomcat base image
FROM tomcat:9-jdk11

# Set the working directory to the Tomcat webapps folder
WORKDIR /usr/local/tomcat/webapps/

# Copy the .war file into the Tomcat webapps directory
# This assumes Jenkins will place the WAR file in ./target/my-application.war
COPY ./target/my-application.war ./ROOT.war

# Expose port 8080 to allow access to the web application
EXPOSE 8080

# Command to start Tomcat when the container runs
CMD ["catalina.sh", "run"]
