# Build Stage
FROM gradle:8.12.1-jdk17-focal AS build
COPY . /apps
WORKDIR /apps
RUN gradle build 

# Runtime Stage
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
