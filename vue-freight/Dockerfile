FROM nginx

LABEL maintainer="liuze"  

RUN rm /etc/nginx/conf.d/default.conf

ADD default.conf /etc/nginx/conf.d/

EXPOSE 80

COPY dist/  /usr/share/nginx/html/


