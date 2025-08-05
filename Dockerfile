# ----------- Build Stage -----------
FROM maven:3.9.11-amazoncorretto-17-al2023 AS build

WORKDIR /app

# Copy pom.xml and resolve dependencies first (caching optimization)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application (skip tests for faster build)
RUN mvn clean package -DskipTests -B


# ----------- Run Stage -----------
FROM openjdk:17-jdk-slim

WORKDIR /app

# Install debugging tools (optional)
RUN apt-get update && apt-get install -y netcat-traditional && rm -rf /var/lib/apt/lists/*

# Copy the built JAR from the build stage
COPY --from=build /app/target/Shopping_Cart-0.0.1-SNAPSHOT.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the JAR with optimized settings
ENTRYPOINT ["java", "--enable-native-access=ALL-UNNAMED", "-Xms512m", "-Xmx1024m", "-jar", "app.jar"]