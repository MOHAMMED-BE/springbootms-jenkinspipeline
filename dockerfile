FROM eclipse-temurin:17-jre
WORKDIR /app
COPY runner-ms/target/runner-ms-1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENV PORT=8080
ENTRYPOINT ["java","-jar","/app/app.jar"]