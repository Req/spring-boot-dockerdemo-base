FROM eclipse-temurin:latest
LABEL authors="joel"
WORKDIR /app

# COPY target/dockerdemo-0.0.1-SNAPSHOT.jar inside.jar
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline

COPY src ./src

EXPOSE 8080

ENTRYPOINT ["./mvnw", "spring-boot:run"]