# Use the Maven image to build the project
FROM maven:3.8.4-openjdk-11 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml to download dependencies (caching layer)
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy the entire project source
COPY src ./src

# Build the project
RUN mvn clean install

# Use a lighter JRE image for running the application
FROM openjdk:11-jre-slim

# Set the working directory for runtime
WORKDIR /app

# Copy the generated JAR file from the build stage
COPY --from=build /app/target/your-app.jar /app/your-app.jar

# Expose the port your app will use
EXPOSE 8080

# Command to run the app
CMD ["java", "-jar", "your-app.jar"]
