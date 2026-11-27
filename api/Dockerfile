# Étape 1 : compilation avec Maven
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q package -DskipTests

# Étape 2 : image d'exécution, utilisateur sans privilèges
FROM eclipse-temurin:21-jre
RUN groupadd --system app \
 && useradd --system --gid app --no-create-home --shell /usr/sbin/nologin app
WORKDIR /app
COPY --from=build --chown=app:app /app/target/spring-petclinic-rest-*.jar app.jar
USER app
EXPOSE 9966
ENTRYPOINT ["java", "-jar", "app.jar"]
