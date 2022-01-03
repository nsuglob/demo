FROM nginx:1.21.4-alpine

WORKDIR /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY . .
COPY ./conf/ /etc/letsencrypt/

RUN sed -i '1 i\load_module /etc/nginx/modules/ngx_http_image_filter_module.so;' /etc/nginx/nginx.conf

