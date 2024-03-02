# Use a base image with Java and Maven installed
FROM maven:3.8.3-openjdk-11-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven POM file
COPY pom.xml .

# Copy the entire project (except what's ignored by .dockerignore) into the container
COPY src ./src

# Build the application with Maven
RUN mvn clean package -DskipTests

# Use a smaller base image for the application runtime
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file built in the previous stage
COPY --from=build /app/target/spring-petclinic-2.4.2.war ./app.war

EXPOSE 8080
# Command to run the application
CMD ["java", "-jar", "app.war"]
