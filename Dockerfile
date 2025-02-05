FROM gradle:8.12.1-jdk17 AS build
WORKDIR /app
COPY gradlew gradlew.bat /app/
COPY gradle /app/gradle/
COPY build.gradle /app/
COPY settings.gradle /app/
COPY src /app/src/
RUN chmod +x gradlew
RUN ./gradlew clean build 


FROM eclipse-temurin:17-jdk-alpine AS runtime
LABEL project="java" \
      author="vijay"

ARG USERNAME=john
ARG GROUP=john
RUN addgroup -S ${GROUP} && adduser -S ${USERNAME} -G ${GROUP}

WORKDIR /apps
COPY --from=build /apps/build/libs/*.jar /apps/gradle-1.0-snapshot.jar
RUN chown ${USERNAME}:${GROUP} /apps/gradle-1.0-snapshot.jar

USER ${USERNAME}
EXPOSE 8080
CMD ["java", "-jar", "gradle-1.0-snapshot.jar"]
