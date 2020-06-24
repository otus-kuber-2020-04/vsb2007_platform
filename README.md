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

## ДЗ:06
1. Создали и запустили minio (S3) в Statefulset
2. Cоздали Secret для minio, зашифровали через base64
3. Изменили minio-statefulset.yaml - убрали открытые данные, заменив на данные из secret

## ДЗ:07
1. Запустили кластер, установили helm
2. Установили nginx-ingress, используя helm-3. Версия 1.11.1 не встала. Номер версии убрал
3. Установили CRD для cert-manager, согласно докоментации, версии v0.15.1
4. Установили cert-manager
5. Дополнительно установили Issuer для тестирования - test-resources.yaml
6. Проверили, что все ок.
7. Создали Basic ACME Issuer - letsencryp-acme.yml - установил production сервер
8. Модифицировал данные в volume.yaml для chartmuseum согласно описанию https://cert-manager.io/docs/usage/ingress/ и установил, сертификат подхватился.
9. Работа с chartmuseum:
    - helm repo add chartmuseum https://chartmuseum.35.238.80.184.nip.io
    - для примера взял чарт cert-manager/
    - helm plugin install https://github.com/chartmuseum/helm-push.git
    - Включил api в values
    - helm push cert-manager/ chartmuseum
    - далее для установки helm install chartmuseum/cert-manager
10. Harbor:
    - взял values.yaml c гитхаба
    - отключил notary
    - добавил домен для core, подключил cert-manager
    - уставновил harbor
11. hipster-shop:
    - Скачал all-hipster-shop.yaml
    - Выпилил deployment, service, создал ingress для frontend
    - Шаблонизировал, создал values.yaml
    - Без шаблонизации выпилил redis, подключил как dependencies
12. работу с secrets пропустил
13. Положил в харбор hipster-shop/, frontend/, redis/
14. kubecfg
    - Скачал локально kube.libsonnet - поменял версию api а deployment на "apps/v1"
    - восстановил работу сервисов
15. kustomize
    - вынес productcatalogservice
    - kubectl apply -k kubernetes-templating/kustomize/overrides/hipster-shop -n hipster-shop # - вернул сервис обратно

## ДЗ:08
1. Созданы все файлы согласно ДЗ
2. Собран и выложен образ на dockerhub
Как проверить работоспособность:
```
$ export MYSQLPOD=$(kubectl get pods -l app=mysql-instance -o jsonpath="{.items[*].metadata.name}")
$ kubectl exec -it $MYSQLPOD -- mysql -potuspassword -e "select * from test;" otus-database
mysql: [Warning] Using a password on the command line interface can be insecure.
+----+-------------+
| id | name        |
+----+-------------+
|  1 | some data   |
|  2 | some data-2 |
+----+-------------+

$ kubectl get jobs
NAME                         COMPLETIONS   DURATION   AGE
backup-mysql-instance-job    1/1           4s         13h
restore-mysql-instance-job   1/1           32s        13h
```
