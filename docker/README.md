# Docker Network Setup - База данных и клиент

## Описание

Проект демонстрирует настройку сети из двух Docker контейнеров:
- **test-db** - контейнер с PostgreSQL базой данных
- **client** - контейнер-точка входа для подключения к БД и выполнения запросов

Данные в базе данных сохраняются при перезапуске контейнеров благодаря использованию Docker volumes.

## Структура проекта

```
docker/
├── db/
│   ├── Dockerfile          # Образ PostgreSQL с настройками
│   └── create_db.sql       # SQL скрипт для инициализации БД
├── client/
│   ├── Dockerfile          # Образ клиента с PostgreSQL клиентом
│   └── connect.sh          # Скрипт подключения к БД
├── docker-compose.yml      # Конфигурация всей системы
└── README.md               # Документация проекта
```

## Требования

- Docker
- Docker Compose

## Команды для запуска

### 1. Сборка и запуск контейнеров

```bash
# Собрать и запустить все контейнеры в фоновом режиме
docker-compose up -d --build
```

### 2. Просмотр логов

```bash
# Просмотр логов всех контейнеров
docker-compose logs

# Просмотр логов конкретного контейнера
docker-compose logs test-db
docker-compose logs client

# Просмотр логов в реальном времени
docker-compose logs -f
```

### 3. Подключение к клиентскому контейнеру

```bash
# Войти в интерактивную сессию клиентского контейнера
docker-compose exec client bash

# Или использовать psql напрямую
docker-compose exec client psql -h test-db -U admin -d training_db
```

### 4. Подключение к базе данных напрямую

```bash
# Подключиться к PostgreSQL контейнеру
docker-compose exec test-db psql -U admin -d training_db
```

## Тестирование

### Тест 1: Проверка подключения и чтения данных

```bash
# Запустить контейнеры
docker-compose up -d

# Просмотреть логи клиента (должны показать содержимое таблицы customers)
docker-compose logs client
```

Ожидаемый результат: в логах должны отображаться записи из таблицы `customers`:
- Иван Иванов, ivan@example.com
- Мария Петрова, maria@example.com

### Тест 2: Добавление новых данных и проверка сохранения

```bash
# Добавить новую запись через клиентский контейнер
docker-compose exec client psql -h test-db -U admin -d training_db -c "INSERT INTO customers (full_name, email) VALUES ('Петр Сидоров', 'petr@example.com');"

# Проверить, что данные добавлены
docker-compose exec client psql -h test-db -U admin -d training_db -c "SELECT * FROM customers;"
```

### Тест 3: Проверка персистентности данных

```bash
# 1. Добавить данные
docker-compose exec client psql -h test-db -U admin -d training_db -c "INSERT INTO customers (full_name, email) VALUES ('Анна Козлова', 'anna@example.com');"

# 2. Остановить все контейнеры
docker-compose down

# 3. Запустить контейнеры заново
docker-compose up -d

# 4. Подождать несколько секунд для инициализации БД, затем проверить данные
docker-compose exec client psql -h test-db -U admin -d training_db -c "SELECT * FROM customers;"
```

Ожидаемый результат: все данные должны сохраниться, включая только что добавленную запись.

### Тест 4: Проверка через прямой запрос из клиента

```bash
# Выполнить несколько запросов
docker-compose exec client psql -h test-db -U admin -d training_db << EOF
SELECT COUNT(*) as total_customers FROM customers;
SELECT full_name, email FROM customers ORDER BY customer_id;
EOF
```

## Остановка и очистка

### Остановка контейнеров (данные сохраняются)

```bash
docker-compose down
```

### Остановка контейнеров и удаление volumes (удаление всех данных)

```bash
docker-compose down -v
```

⚠️ **Внимание**: Команда `down -v` удалит все данные из базы!

## Конфигурация

### Параметры базы данных

В файле `docker-compose.yml` настроены следующие параметры:

- **Хост БД**: `test-db`
- **Пользователь**: `admin`
- **Пароль**: `adminpass`
- **Имя БД**: `training_db`
- **Порт**: `5432` (по умолчанию)

Эти параметры можно изменить в `docker-compose.yml` или через переменные окружения.

### Структура базы данных

База данных содержит таблицу `customers`:

```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);
```

## Персистентность данных

Данные сохраняются благодаря использованию именованного Docker volume `pgdata`, который монтируется в контейнер базы данных:

```yaml
volumes:
  - pgdata:/var/lib/postgresql/data
```

Этот volume создается автоматически при первом запуске и сохраняет все данные PostgreSQL даже при перезапуске или удалении контейнеров.

## Устранение неполадок

### Проблема: клиент не может подключиться к БД

```bash
# Проверить, что оба контейнера запущены
docker-compose ps

# Проверить логи БД на наличие ошибок
docker-compose logs test-db

# Проверить сеть
docker network ls
docker network inspect docker_mynet
```

### Проблема: данные не сохраняются

```bash
# Проверить наличие volume
docker volume ls
docker volume inspect docker_pgdata

# Проверить, что volume смонтирован в контейнер
docker-compose exec test-db df -h
```

## Дополнительные полезные команды

```bash
# Пересобрать образы без кеша
docker-compose build --no-cache

# Просмотр использования ресурсов
docker stats

# Просмотр информации о сети
docker network inspect docker_mynet

# Просмотр списка volumes
docker volume ls
```

