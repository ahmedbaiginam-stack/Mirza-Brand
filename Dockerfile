# STEP 1: Build the Java code using Maven
FROM maven:3.8.4-openjdk-11 AS build
WORKDIR /app
# Copy your pom.xml and the entire src folder
COPY . .
# Compile the code and package it into a .war file
RUN mvn clean package -DskipTests

# STEP 2: Run the compiled code in Tomcat
FROM tomcat:9.0-jdk11-openjdk
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the built WAR from the 'build' stage and name it ROOT.war
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]