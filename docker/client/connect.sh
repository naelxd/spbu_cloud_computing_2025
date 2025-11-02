#!/bin/bash

# Переменные для подключения
DB_HOST=${DB_HOST:-test-db}
DB_PORT=${DB_PORT:-5432}
DB_USER=${DB_USER:-admin}
DB_PASS=${DB_PASSWORD:-adminpass}
DB_NAME=${DB_NAME:-training_db}

export PGPASSWORD=$DB_PASS

echo "Попытка подключиться к базе на $DB_HOST:$DB_PORT..."

# Ждём, пока БД станет доступна
until psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c '\q'; do
  echo "PostgreSQL недоступен, пробуем снова через 2 секунды..."
  sleep 2
done

echo "Подключение прошло успешно!"
echo "Содержимое таблицы customers:"
psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "SELECT * FROM customers;"

psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c "INSERT INTO customers (full_name, email) VALUES ('Достоевский Федор', 'fedor@example.com')"

exec bash

