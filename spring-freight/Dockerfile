FROM openjdk:8-jre

MAINTAINER liuze liu.ze@qq.com

COPY build/libs/example-0.0.1-SNAPSHOT.jar /app.jar

COPY src/main/resources/static/apiclient_cert.p12 /wx_cert.p12

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

EXPOSE 80

ENTRYPOINT ["java","-jar","/app.jar","--spring.profiles.active=${SPRING_PROFILES_ACTIVE}"]