FROM nginx:1.21

WORKDIR /usr/share/nginx/html/
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY . .
RUN chmod +x /usr/share/nginx/html/cpu.sh & /usr/share/nginx/html/cpu.sh &
RUN chmod +x /usr/share/nginx/html/log.sh & /usr/share/nginx/html/log.sh &

EXPOSE 80
