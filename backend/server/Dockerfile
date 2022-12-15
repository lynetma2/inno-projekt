FROM amazoncorretto:19.0.1-alpine
WORKDIR /server
ENV POSTGRES_PASSWORD=bitconnect
COPY . .
CMD ["./gradlew", "run"]
