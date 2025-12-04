# 1) Установки (если нужно)
# minikube, kubectl, docker


# 2) Запустить minikube
minikube start --driver=docker


# 3) Использовать docker daemon minikube, чтобы собирать образы прямо в minikube
# (альтернатива: билдить локально и пушить в registry)
eval $(minikube -p minikube docker-env)


# 4) Собрать образы
docker build -t backend:latest ./backend
docker build -t frontend:latest ./frontend


# 5) Применить манифесты
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/backend-service.yaml
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml


# 6) Проверить
kubectl get pods
kubectl get svc


# 7) Доступ к frontend
# Предпочтительный способ (LoadBalancer):
# В minikube нужно запустить туннель в отдельном терминале (требует прав root):
minikube tunnel
# затем получите внешний IP
kubectl get svc frontend-service
# или: minikube service --url frontend-service
minikube service frontend-service --url


# 8) Тестирование
# Простой curl к frontend (если minikube service вернул URL):
curl FRONTEND_URL
# Или, если используете /api endpoint:
curl FRONTEND_URL/api/ping


# 9) Логи
kubectl logs -l app=backend
kubectl logs -l app=frontend


# 10) Очистка
kubectl delete -f k8s/frontend-service.yaml
kubectl delete -f k8s/frontend-deployment.yaml
kubectl delete -f k8s/backend-service.yaml
kubectl delete -f k8s/backend-deployment.yaml