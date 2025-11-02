-- Создаём дополнительного пользователя
CREATE USER training_user WITH PASSWORD '12345';

-- Даём ему доступ к базе
GRANT CONNECT ON DATABASE training_db TO training_user;

\c training_db;

-- Создаём таблицы
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO customers (full_name, email)
VALUES
  ('Иван Иванов', 'ivan@example.com'),
  ('Мария Петрова', 'maria@example.com');

-- Даём права пользователю
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO training_user;

