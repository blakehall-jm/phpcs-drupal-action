FROM php:8.2-cli-alpine
USER root
ENV PATH=${PATH}:/root/.composer/vendor/bin
# To be able to download ca-certificates with the `apk add` command
# Adapted from https://stackoverflow.com/questions/67231714/how-to-add-trusted-root-ca-to-docker-alpine
COPY local-root-ca.crt /root/local-root-ca.crt
RUN cat /root/local-root-ca.crt >> /etc/ssl/certs/ca-certificates.crt
# Add again root CA with `update-ca-certificates` tool
RUN apk add --no-cache \
    --repository https://dl-cdn.alpinelinux.org/alpine/v3.19/main \
    ca-certificates && \
    rm -rf /var/cache/apk/*
COPY local-root-ca.crt /usr/local/share/ca-certificates
RUN update-ca-certificates
RUN apk add --no-cache \
    git && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true && \
    composer global require drupal/coder squizlabs/php_codesniffer && \
    phpcs --config-set default_standard Drupal,DrupalPractice
COPY app /app
RUN chmod +x /app/entrypoint.sh
WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
