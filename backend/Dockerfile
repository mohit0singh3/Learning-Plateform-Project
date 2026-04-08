FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy only pom.xml first (faster build)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy rest of code
COPY src ./src

# Build project
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
