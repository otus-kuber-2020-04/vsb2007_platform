# vsb2007_platform
vsb2007 Platform repository

## ДЗ:01
- Установил kubectl и автодополнение.
- Установил и Запустил minikube.
- Проверил, что в кластере восстанавливаются поды после удаления: core-dns - как ReplicaSet, остальные kube-apiserver
  скорее всего контролируются системными процессами - но это не очевидно в отличии от core-dns.
- Создал Dockerfile для http сервера - на python http.server.
- Создал манифест web-pod.yaml, согласно дз - посмотрел все стадии запуска, случано его удалил и восстановил из команды `kubectl get pod web -o yaml`.
- С помощью `kubectl port-forward --address 0.0.0.0 pod/web 8000:8000` подцепился к страничке из init контейнера.
- Скопировал репозиторий hipster shop, собрал/запушил образ frontend
- Запустил под frontend - добавил необходимые переменные в env для запуска frontend-pod-healthy.yaml


