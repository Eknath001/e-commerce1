# Use the official OpenJDK 17 slim image as base
FROM openjdk:17-jdk-slim

# Argument for the JAR file path (built by Maven/Gradle)
ARG JAR_FILE=target/Shopping_Cart-0.0.1-SNAPSHOT.jar

# Copy the JAR file from the build context to the image and rename it
COPY ${JAR_FILE} Shopping_Cart.jar

# Expose port 8080 (Spring Boot default)
EXPOSE 8080

# Set the entry point to run the application
ENTRYPOINT ["java", "-jar", "Shopping_Cart.jar"]
