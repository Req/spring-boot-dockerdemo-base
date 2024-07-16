FROM eclipse-temurin:latest
LABEL authors="joel"
WORKDIR /app

# If we build the jar locally using maven we could copy and run that 
# COPY target/dockerdemo-0.0.1-SNAPSHOT.jar inside.jar
# CMD ["java", "-jar", "target/dockerdemo-0.0.1-SNAPSHOT.jar]

# But we probably want to build the jar *inside* the container
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# This downloads the dependencies and plugins we need to build locally
RUN ./mvnw dependency:go-offline
COPY src ./src

# This is the port that the app will run on
EXPOSE 8080

# This is the command that will be run when the container starts
ENTRYPOINT ["./mvnw", "spring-boot:run"]