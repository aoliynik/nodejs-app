ARG IMAGE_BASE=16-alpine

FROM node:$IMAGE_BASE
ENV NODE_ENV production

# Install nginx and supervisord
RUN apk add --no-cache bash git nginx python py2-pip && \
    pip install wheel && \
    pip install supervisor supervisor-stdout && \
    rm -rf /etc/nginx/conf.d/default.conf

# Add supervisor configs
ADD ./supervisord.conf /etc/supervisord.conf

# Override Nginx's default config
ADD nginx/default.conf /etc/nginx/conf.d/default.conf

# Add startup script
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

WORKDIR /app

# For Docker layer caching do this BEFORE copying in rest of app
COPY src/package*.json ./
RUN npm install --production --silent

# NPM is done, now copy in the rest of the project to the workdir
COPY src/. .

# Expose Nginx port
EXPOSE 8080

WORKDIR /
CMD ["/start.sh"]
