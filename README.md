# vsb2007_platform
vsb2007 Platform repository

## ДЗ:02
- Установил kubectl и автодополнение.
- Установил и Запустил minikube.
- Проверил, что в кластере восстанавливаются поды после удаления: core-dns - как ReplicaSet, остальные kube-apiserver
  скорее всего контролируются системными процессами - но это не очевидно в отличии от core-dns.
- Создал Dockerfile для http сервера - на python http.server.
- Создал манифест web-pod.yaml, согласно дз - посмотрел все стадии запуска, случано его удалил и восстановил из команды `kubectl get pod web -o yaml`.
- С помощью `kubectl port-forward --address 0.0.0.0 pod/web 8000:8000` подцепился к страничке из init контейнера.
- Скопировал репозиторий hipster shop, собрал/запушил образ frontend
- Запустил под frontend - добавил необходимые переменные в env для запуска frontend-pod-healthy.yaml


## ДЗ:03
- Установил kind и создал кластер
- Созлал и запустил манифест replicaset
- Поигрались с количеством подов и версиями образов в replicaset. Поды с отличной версией не появляются,
  т.к. replicaset не перезпускает поды, а только следит за количеством.
- Создал и запушил образы paymentService.
- Создал манифест paymentservice-replicaset.yaml
- Создал манифест paymentservice-deployment.yaml
- Запустил paymentservice-deployment.yaml с разными версиями образа, сделал rollout.
- Создал манифесты с различными стратегиями обновления подов paymentservice-deployment-bg.yaml и paymentservice-deployment-reverse.yaml
- Создал манифест frontend-deployment.yaml, добавил readinessProbe - попровал не рабочий readinessProbe - обновление подов не проходит
- Создал манифест node-exporter-daemonset.yaml - нашел в [инете](https://raw.githubusercontent.com/coreos/kube-prometheus/master/manifests/node-exporter-daemonset.yaml)
для развертывания на мастер-нодах нужно добавить следующее:
```
      tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule
```
но уже было добавлено:
```
      tolerations:
      - operator: Exists
```
что тоже работает....

## ДЗ:04

- task01
1. Создать Service Account bob, дать ему роль admin в рамках всего кластера
2. Создать Service Account dave без доступа к кластеру

- task02
1. Создать Namespace prometheus
2. Создать Service Account carol в этом Namespace
3. Дать всем Service Account в Namespace prometheus возможность делать get, list, watch в отношении Pods всего кластера

- task03
1. Создать Namespace dev
2. Создать Service Account jane в Namespace dev
3. Дать jane роль admin в рамках Namespace dev
4. Создать Service Account ken в Namespace dev
5. Дать ken роль view в рамках Namespace dev

## ДЗ:05
1. Поиграли с readinessProbe и livenessProbe
2. Создали Deployment
3. Создали Service (ClusterIP)
4. Включили режим IPVS
5. Установили MetalLB
6. Прописали маршрут до MetalLB через minikube
7. Достучались до приложения
8. Открыли CoreDNS через MetalLB
9. Создали ingress-nginx
10. Подключили приложение web через ingress-nginx
11. Установили dashboard, настроили ingress-nginx - проблему с https пришлось погуглить
12. Canary - не сделал
