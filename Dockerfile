FROM openjdk:17-slim AS runner
ENV CI=true
WORKDIR /app

FROM maven:3.9.8-amazoncorretto-17 AS builder
ENV CI=true
WORKDIR /app

FROM builder AS build
COPY . /app/
RUN mvn package -Dclassifier=exec -DskipTests

RUN ls /app/target

FROM runner
COPY --from=build /app/target/demo.jar /opt/app.jar
EXPOSE 8080
CMD ["java", "-jar", "/opt/app.jar"]
