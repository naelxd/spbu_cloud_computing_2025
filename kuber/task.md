Описание: Деплой backend-frontend приложения используя Kubernetes.
● Backend: приложение, которое слушает внутренний порт и отправляет
ответ, если пришел запрос. Должно быть реплицировано.
● Frontend: приложение, которое слушает внешний порт и отправляет
входящие запросы на backend. Должен иметь IP, который может быть
использован вне кластера.

DoD: GitLab/GitHub репозиторий с backend Deployment YAML, frontend Deployment
YAML, backend Service YAML, frontend Service YAML, README со списком команд для
запуска и тестирования + дополнительные файлы для работы системы.