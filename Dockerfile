# Stage 1: Build the app using Maven
FROM maven:3.8.4-openjdk-11 AS build
WORKDIR /app
COPY . .
# This compiles your .java files into .class files
RUN mvn clean package -DskipTests

# Stage 2: Run the app in Tomcat
FROM tomcat:9.0-jdk11-openjdk
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the generated WAR file from the build stage to Tomcat
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]