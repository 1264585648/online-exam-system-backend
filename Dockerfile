# Build with the Java version declared in pom.xml (1.8).
# The previous image used openjdk:17 while the compiler target is 1.8.
FROM maven:3.8.8-eclipse-temurin-8 AS build
WORKDIR /src
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests package

FROM eclipse-temurin:8-jre-jammy
WORKDIR /app
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /src/target/exam-1.0-SNAPSHOT.jar /app/exam.jar
COPY src/main/resources/ipdata /app/src/main/resources/ipdata
EXPOSE 8080
ENV SPRING_PROFILES_ACTIVE=docker
ENTRYPOINT ["java", "-jar", "/app/exam.jar"]
