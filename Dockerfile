FROM tomcat:9.0-jdk11-openjdk

# 1. Clean out the webapps AND the work directory
RUN rm -rf /usr/local/tomcat/webapps/* && rm -rf /usr/local/tomcat/work/*

# 2. Copy your application
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# 3. Ensure Tomcat has permission to write to its own folders
RUN chmod -R 777 /usr/local/tomcat/work /usr/local/tomcat/temp /usr/local/tomcat/logs

EXPOSE 8080
CMD ["catalina.sh", "run"]