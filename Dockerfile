FROM maven:3-jdk-8 as package-builder
COPY . .
RUN mvn clean package


FROM openjdk:8-jre-alpine3.9
COPY --from=package-builder /target/metadata-service.jar /home
RUN apk update && \
    apk add curl
ARG PORT
ARG MONGOLAB_URI
ENV PORT=${PORT}
ENV MONGOLAB_URI=${MONGOLAB_URI}
ENTRYPOINT java -jar /home/metadata-service.jar --server.port=$PORT --spring.data.mongodb.uri=$MONGOLAB_URI