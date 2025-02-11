FROM gradle:8.12.1-jdk17 AS build
COPY complete /apps
COPY . /apps
WORKDIR /apps
RUN gradle clean build --no-daemon --info

FROM eclipse-temurin:17-jdk-alpine AS runtime
LABEL project="java" \
      author="vijay"

ARG USERNAME=john
ARG GROUP=john
RUN addgroup -S ${GROUP} && adduser -S ${USERNAME} -G ${GROUP}

WORKDIR /apps
COPY --from=build /apps/build/libs/*.jar /apps/app.jar
RUN chown ${USERNAME}:${GROUP} /apps/app.jar
RUN chmod +x /apps/app.jar

USER ${USERNAME}
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
