FROM postgres:16

ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=adminpass
ENV POSTGRES_DB=training_db

COPY create_db.sql /docker-entrypoint-initdb.d/
