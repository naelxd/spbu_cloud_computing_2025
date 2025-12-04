# Kubernetes Deployment: FastAPI Backend + Nginx Frontend

## 1) Установки (если нужно)

Установите необходимые инструменты: `minikube`, `kubectl`, `docker`

## 2) Запустить minikube

```bash
minikube start --driver=docker
```

## 3) Использовать docker daemon minikube

Чтобы собирать образы прямо в minikube (альтернатива: билдить локально и пушить в registry):

```bash
eval $(minikube -p minikube docker-env)
```

## 4) Собрать образы

```bash
docker build -t backend:latest ./backend
docker build -t frontend:latest ./frontend
```

## 5) Применить манифесты

```bash
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/backend-service.yaml
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml
```

## 6) Проверить

```bash
kubectl get pods
kubectl get svc
```

## 7) Доступ к frontend

**Предпочтительный способ (LoadBalancer):**

В minikube нужно запустить туннель в отдельном терминале (требует прав root):

```bash
minikube tunnel
```

Затем получите внешний IP:

```bash
kubectl get svc frontend-service
```

Или используйте:

```bash
minikube service frontend-service --url
```

## 8) Тестирование

Простой curl к frontend (если minikube service вернул URL):

```bash
curl FRONTEND_URL
```

Или, если используете `/api` endpoint:

```bash
curl FRONTEND_URL/api/ping
```

## 9) Логи

```bash
kubectl logs -l app=backend
kubectl logs -l app=frontend
```

## 10) Очистка

```bash
kubectl delete -f k8s/frontend-service.yaml
kubectl delete -f k8s/frontend-deployment.yaml
kubectl delete -f k8s/backend-service.yaml
kubectl delete -f k8s/backend-deployment.yaml
```
