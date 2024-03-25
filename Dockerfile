FROM openjdk:17
COPY backend/build/libs/pickachu-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]
