# ----------- Build Stage -----------
FROM maven:3.9.11-amazoncorretto-17-al2023 AS build

WORKDIR /app

# Copy pom.xml and resolve dependencies first (caching optimization)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the application (skip tests for faster build)
RUN mvn clean package -DskipTests


# ----------- Run Stage -----------
FROM openjdk:24-slim-bullseye

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/Shopping_Cart-0.0.1-SNAPSHOT.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
