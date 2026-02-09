# Build stage: compile the WAR with Maven
FROM maven:3.8-eclipse-temurin-8 AS builder
WORKDIR /app

# Copy pom and build (download dependencies)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build WAR
COPY src ./src
RUN mvn clean package -DskipTests -B

# Run stage: Tomcat with the WAR
FROM tomcat:9.0-jdk8
WORKDIR /usr/local/tomcat

# Remove default webapps
RUN rm -rf webapps/*

# Copy built WAR from builder (adapt path if your artifactId/version differs)
COPY --from=builder /app/target/*.war webapps/ROOT.war

# Render sets PORT. Make Tomcat listen on it at runtime.
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
EXPOSE 8080
CMD ["/usr/local/bin/start.sh"]
