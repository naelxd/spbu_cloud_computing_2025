FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*


COPY connect.sh /usr/local/bin/connect.sh
RUN chmod +x /usr/local/bin/connect.sh

# По умолчанию запускаем скрипт
CMD ["/usr/local/bin/connect.sh"]

