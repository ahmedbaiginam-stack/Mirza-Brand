# Stage 1: Build with Maven
FROM maven:3.8.4-openjdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run with Tomcat
FROM tomcat:9.0-jdk11-openjdk
RUN rm -rf /usr/local/tomcat/webapps/* && rm -rf /usr/local/tomcat/work/*
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war
RUN chmod -R 777 /usr/local/tomcat/work /usr/local/tomcat/temp /usr/local/tomcat/logs

EXPOSE 8080
CMD ["catalina.sh", "run"]