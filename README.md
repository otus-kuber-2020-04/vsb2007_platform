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

## ДЗ:09
1. Посмотрел доку на ngx_http_stub_status_module
2. Проверил что обычный образ nginx уже собран с этим модулем `nginx -V 2>&1 | grep -o with-http_stub_status_module`
3. Создал конфиг для кубера с `location = /basic_status`
4. Через волюм подцепил его nginx
5. Запустил nginx/nginx-prometheus-exporter:0.8.0 в кубере
6. Выпустил через сервис
7. Сервисы - тестировались на кубере с metallb

## ДЗ:10
1. Запустили HipsterShop в созданном в GCP кластере
2. Установили EFK, Porometheus operator
3. Установили nginx-ingress (правильный репо для helm stable/nginx-ingress), поменял конфиг для логов в json
4. Обновили релизы с учетом доступа к kibana, grafana, prometheus через полученный ip
5. запустили Fluent Bit
6. В ELK пересоздал индекс
7. Создал визуализации в kibana
8. Установил Loki
9. Для prometheus добавил additionalDataSources для Loki
10. В prometheus создал дашборад с панелями

## ДЗ 12
1. 
```$ helm status vault
NAME: vault
LAST DEPLOYED: Thu Aug 13 20:50:56 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing HashiCorp Vault!

Now that you have deployed Vault, you should look over the docs on using
Vault with Kubernetes available here:

https://www.vaultproject.io/docs/


Your release is named vault. To learn more about the release, try:

  $ helm status vault
  $ helm get vault
```
2.
```
Unseal Key 1: hWbweUeuAhiuMEGM6O5UgEeC6VrSdp1ssogz4Hvec4E=
Initial Root Token: s.Asow40x0fVnCXmiiJth0SEFo
```
3.
```
$ kubectl exec -ti vault-0 -- vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.4.2
Cluster Name    vault-cluster-b10d4334
Cluster ID      0cb3776e-6894-21fd-c05a-40bccfb42e99
HA Enabled      true
HA Cluster      https://vault-0.vault-internal:8201
HA Mode         active
```
4.
```
$ kubectl exec -it vault-0 -- vault login
Token (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.Asow40x0fVnCXmiiJth0SEFo
token_accessor       DFTACQEyOejMoWHQhVquLHj7
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```
5.
```
$ kubectl exec -it vault-0 -- vault login
Token (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                s.Asow40x0fVnCXmiiJth0SEFo
token_accessor       DFTACQEyOejMoWHQhVquLHj7
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
k8s@book:~/k8s/vsb2007_platform$ kubectl exec -it vault-0 -- vault auth list
Path      Type     Accessor               Description
----      ----     --------               -----------
token/    token    auth_token_0bcdc86d    token based credentials
```
6.
```
$ kubectl exec -it vault-0 -- vault read otus/otus-ro/config
Key                 Value
---                 -----
refresh_interval    768h
password            asajkjkahs
username            otus
$ kubectl exec -it vault-0 -- vault kv get otus/otus-rw/config
====== Data ======
Key         Value
---         -----
password    asajkjkahs
username    otus
```
7.
```
$ kubectl exec -it vault-0 -- vault auth list
Path           Type          Accessor                    Description
----           ----          --------                    -----------
kubernetes/    kubernetes    auth_kubernetes_6f27e6d1    n/a
token/         token         auth_token_0bcdc86d         token based credentials
```
8. Для записи в `otus-rw` обновили до состояния:
```
path "otus/otus-rw/*" {
capabilities = ["read", "update", "create", "list"]
}
```
9.
```
$ kubectl exec -ti vault-agent-example cat /usr/share/nginx/html/index.html
<html>
<body>
<p>Some secrets:</p>
<ul>
<li><pre>username: otus</pre></li>
<li><pre>password: asajkjkahs</pre></li>
</ul>

</body>
</html>
```
10.
```
$ kubectl exec -it vault-0 -- vault write pki_int/issue/example-dot-ru common_name="gitlab.example.ru" ttl="24h"
Key                 Value
---                 -----
ca_chain            [-----BEGIN CERTIFICATE-----
MIIDnDCCAoSgAwIBAgIUQCTvO3FvHdxHtht3pXPGQiyedj0wDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKZXhtYXBsZS5ydTAeFw0yMDA4MTMyMTE1MjZaFw0yNTA4
MTIyMTE1NTZaMCwxKjAoBgNVBAMTIWV4YW1wbGUucnUgSW50ZXJtZWRpYXRlIEF1
dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL2R7VTqHjQL
Um+byZE+rxFC+NG1lo93fqqaTiXeTIuM/oCCdu/i0JGQ/eYqaK5DKO7lcY6jIbjU
oPKb5iKAqJpApzbGVsNGEkuIbN5PC64mMuGih0HEJ/dVugL2D4Kx0ds1Zp2ZE2CC
OPhlNQHSXCerRgaIy7UBuf+Ic2Tt5B8XV4SyUFWMFNuQCs8/2WyLQ09KmHUYFjx7
nTI+x97kRUsnAX6yJLCsfWk+kwsABd6bSfGT8Nx5BPqCUKW/1DQouEl0lnJ/YT0v
GxyYhgWO34DttHuTGpUfM1Mx79mWoimObwygcS/jdGDxUiXMiFVd7oV3phxfA0KM
BSFI5PWIjYECAwEAAaOBzDCByTAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUw
AwEB/zAdBgNVHQ4EFgQUIbjzraHRtNT8IPkf5Mv9UdOZ6X4wHwYDVR0jBBgwFoAU
SuaeCzYFnsiRm0Cot2VHBmEBRvswNwYIKwYBBQUHAQEEKzApMCcGCCsGAQUFBzAC
hhtodHRwOi8vdmF1bHQ6ODIwMC92MS9wa2kvY2EwLQYDVR0fBCYwJDAioCCgHoYc
aHR0cDovL3ZhdWx0OjgyMDAvdjEvcGtpL2NybDANBgkqhkiG9w0BAQsFAAOCAQEA
d70+GGg4jRsqnj+dkvtWpCK9017uewWdKqyd0q/1cVsbb6Uexb0IonCrMbtBQUvC
MSw99CF9kG+PJjYLhdsjEs/EO5dJEnu2fwHy6mPMmdRkjo7Xjo60xTy8FF5Q8TkE
NP0JQXnwJp2hpLJiOpti3ZSkAhD1yajeJ3rnqRsIDdEO/hMEmIJvXUkjckFL2XC4
MXu2+sYxLhgmblxz8+Hiobb0GfakbdKuAbEZkbikPHmZMOHgvtqndd5tgr3LZgeF
JBcaxTdK38RIxOdEpMr/nKBfcOwEQ4IeWLh4lMUm1jQZQQRwLuC0Gb4QDdCoWryO
TIaj5Gs9Ic/CYYDsmLMmwQ==
-----END CERTIFICATE-----]
certificate         -----BEGIN CERTIFICATE-----
MIIDZzCCAk+gAwIBAgIUb+URLIv4wm1yaF19X50SSI7n4lEwDQYJKoZIhvcNAQEL
BQAwLDEqMCgGA1UEAxMhZXhhbXBsZS5ydSBJbnRlcm1lZGlhdGUgQXV0aG9yaXR5
MB4XDTIwMDgxMzIxMjEwMVoXDTIwMDgxNDIxMjEzMVowHDEaMBgGA1UEAxMRZ2l0
bGFiLmV4YW1wbGUucnUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDu
31Qulrx1dVfNAX7K2yRmnLdYC7pvlYw54nmp+cc3HgYXSp+/6zg441YI2fOQuxiT
tbllfS6sH6yVUB7MoehkRgQ+ksy0CF0eASWd52ekrM46Mgm4fBWY8jcQyAAiQiV5
rSWz0z3HpQVq1NgPMiCkRdIb/HkoSJCLkKdswHViTCeeQfbKuVMfjsKEA/bHYnFQ
gLVdZK6OGNCupb0LSO+UGqqo+vkLgaoOYhKx0DWgqVcIL7VB8ORc3PL6UGr6cg4a
FHWg5CaH9U4hKMPHjFRT6HpFV+JcJymCWvniFyCBi2kqKKvptUfXvbEFr1BZXFpW
d/lL8eUx+M8jjyK6RKN7AgMBAAGjgZAwgY0wDgYDVR0PAQH/BAQDAgOoMB0GA1Ud
JQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAdBgNVHQ4EFgQUcWubD9VThBUrzJGO
4EPbQkr9vrgwHwYDVR0jBBgwFoAUIbjzraHRtNT8IPkf5Mv9UdOZ6X4wHAYDVR0R
BBUwE4IRZ2l0bGFiLmV4YW1wbGUucnUwDQYJKoZIhvcNAQELBQADggEBAFTWqRr2
oAUd+/5Vwyul2dpfV0cf2bWOUzS7IUDV1wdvQK1ebLSj4o6VD66PM1qJzw8869gq
ahfdzp+B1oj6SJjTRZ7sQFDXslfBugo8i/4uAAtjo6MjK6PX5TKCopr9EvSDpCWH
MMO2zE+azazhVgiu2a0Kbpa+RCH4Nd2fueOTrdi+9fyhZdyg9npxCGkNXJb62mpH
5uneGgvK+f61rfKec0EACZth6rVuRWtu99fxOl5WBLkXizx6iBFN6sR1Swe0viV4
UFXZ0W1gRP3hdVWZePDLNf4FG4Hg+P5T1xWwt79N9gl9sKTOQv1KdHRCaaSMu3N6
miBExPd6fU5qu9c=
-----END CERTIFICATE-----
expiration          1597440091
issuing_ca          -----BEGIN CERTIFICATE-----
MIIDnDCCAoSgAwIBAgIUQCTvO3FvHdxHtht3pXPGQiyedj0wDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKZXhtYXBsZS5ydTAeFw0yMDA4MTMyMTE1MjZaFw0yNTA4
MTIyMTE1NTZaMCwxKjAoBgNVBAMTIWV4YW1wbGUucnUgSW50ZXJtZWRpYXRlIEF1
dGhvcml0eTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL2R7VTqHjQL
Um+byZE+rxFC+NG1lo93fqqaTiXeTIuM/oCCdu/i0JGQ/eYqaK5DKO7lcY6jIbjU
oPKb5iKAqJpApzbGVsNGEkuIbN5PC64mMuGih0HEJ/dVugL2D4Kx0ds1Zp2ZE2CC
OPhlNQHSXCerRgaIy7UBuf+Ic2Tt5B8XV4SyUFWMFNuQCs8/2WyLQ09KmHUYFjx7
nTI+x97kRUsnAX6yJLCsfWk+kwsABd6bSfGT8Nx5BPqCUKW/1DQouEl0lnJ/YT0v
GxyYhgWO34DttHuTGpUfM1Mx79mWoimObwygcS/jdGDxUiXMiFVd7oV3phxfA0KM
BSFI5PWIjYECAwEAAaOBzDCByTAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUw
AwEB/zAdBgNVHQ4EFgQUIbjzraHRtNT8IPkf5Mv9UdOZ6X4wHwYDVR0jBBgwFoAU
SuaeCzYFnsiRm0Cot2VHBmEBRvswNwYIKwYBBQUHAQEEKzApMCcGCCsGAQUFBzAC
hhtodHRwOi8vdmF1bHQ6ODIwMC92MS9wa2kvY2EwLQYDVR0fBCYwJDAioCCgHoYc
aHR0cDovL3ZhdWx0OjgyMDAvdjEvcGtpL2NybDANBgkqhkiG9w0BAQsFAAOCAQEA
d70+GGg4jRsqnj+dkvtWpCK9017uewWdKqyd0q/1cVsbb6Uexb0IonCrMbtBQUvC
MSw99CF9kG+PJjYLhdsjEs/EO5dJEnu2fwHy6mPMmdRkjo7Xjo60xTy8FF5Q8TkE
NP0JQXnwJp2hpLJiOpti3ZSkAhD1yajeJ3rnqRsIDdEO/hMEmIJvXUkjckFL2XC4
MXu2+sYxLhgmblxz8+Hiobb0GfakbdKuAbEZkbikPHmZMOHgvtqndd5tgr3LZgeF
JBcaxTdK38RIxOdEpMr/nKBfcOwEQ4IeWLh4lMUm1jQZQQRwLuC0Gb4QDdCoWryO
TIaj5Gs9Ic/CYYDsmLMmwQ==
-----END CERTIFICATE-----
private_key         -----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA7t9ULpa8dXVXzQF+ytskZpy3WAu6b5WMOeJ5qfnHNx4GF0qf
v+s4OONWCNnzkLsYk7W5ZX0urB+slVAezKHoZEYEPpLMtAhdHgElnednpKzOOjIJ
uHwVmPI3EMgAIkIlea0ls9M9x6UFatTYDzIgpEXSG/x5KEiQi5CnbMB1YkwnnkH2
yrlTH47ChAP2x2JxUIC1XWSujhjQrqW9C0jvlBqqqPr5C4GqDmISsdA1oKlXCC+1
QfDkXNzy+lBq+nIOGhR1oOQmh/VOISjDx4xUU+h6RVfiXCcpglr54hcggYtpKiir
6bVH172xBa9QWVxaVnf5S/HlMfjPI48iukSjewIDAQABAoIBAQCxb1DPvoZE1aIf
lNHDC18Rna2PCD83baWYxcLL4M77ASFTIcpiO+4qS6v3rTYANwn9hootefw2PNzs
mHQYWtgNy/iRJmhJ/sB0bjOsBFz3dKlHjy2rTPiaAKmonHeE+w9tP5F27x2/87N/
dJT9TKX0gCyfPz4cDzLXiN7kqF1JYorCNA34vDlEmG+x4zwIFaaTnHzN1Phdtp98
6FQztkocrzu5hGrKL6mGpZ1xnrvXlHVMvPKLTRw0bYPXSDl6vKDnE7yuy3Rhrd8n
tO4QyK52wtfnVqOCUKYa7SVWRzlr+jYBx/OSqU6p/og7EMPRefVzH+a2cP5a4vHG
X/MODpRJAoGBAPIv9lDVeV2eRAgpadhajlkezlFICnguMC6zwZzQWdRrgaiQczss
1/QtYXZzujNMTcl8wv3wE2n8aFH1cnsxo204vs0SZJZyKUhYk8uOehAR4qzBJI2j
JdVe0tZylp/azKL/xnGpTkUv5CzgrKUcOwGdi3+dbZHybxHor163SF2tAoGBAPx+
93XeOeKZ005X34THfZcbWM/HyZHzpbxFWFkxSBsNtUAqdjUdC3i/92F69Gyox5Vi
ZRGEIT6byTbTTEAMbFrzhBK87p70w/z2K1rF4ANQyZz6OB9Yy8WHl+8qtwLEVS3Q
qNhYvuMgxeULQNKH3PkXjXowo+0KTWmxhdw5CVrHAoGBAIzGEDjgPRGLwyOzXtDh
okhvPaHFbEB7KIqc9fd+rBhq/QzMGg7VfBl0n2hI0Hys57IskPMmL0K18rVhJFAz
hDkieNWe0VUZuqFQy2fQw2a/3rBn/CVQJdemrIr2RFNazQQaBHFg5hwVQF5Noky+
4hWIS+O70Eq7TpBsXjOB+dBpAoGAbg6RoojIxmKyXhWjUeb6cSD0Zyz4SWvgM94u
EkKO4WvqMxvPBnuwgmN6Wr0TSUGQLScEUsw7CWUyIXmcZNaFbGd0jA5aHGMoAlzy
rNBPQmK2Xnwadl9oAqOFsDP4LXaSgjPPRO351lp0p89t49ZglRqVCkulSC8Taxx7
8m/SCgUCgYBq44hr0/fphrxzuaMwtcxszxftr5ugcJnpW0c/KRWoAdDxZKerrykh
/2zcv0rXz/p1IYFcJCDd7k5O0nTPY+cEbPtFNNlx6dAxz4q4Z6CX1wpADy4Fa/QB
8CR5Xg0nkSh09hi9vaPA6D/A0MqyHOK4c6fOhqRwMBHiYWaliAtk/w==
-----END RSA PRIVATE KEY-----
private_key_type    rsa
serial_number       6f:e5:11:2c:8b:f8:c2:6d:72:68:5d:7d:5f:9d:12:48:8e:e7:e2:51
```

11. Включаем TLS
Генерим сертификат
```
openssl genrsa -out vault.key 4096
```
Создаем фаил `vault-gke-csr.cnf`:
```
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = v3_ext
[ dn ]
commonName = localhost
stateOrProvinceName = Moscow
countryName = RU
emailAddress = 330034@gmail.com
organizationName = Otus
organizationalUnitName = Development
[ v3_ext ]
basicConstraints = CA:FALSE
keyUsage = keyEncipherment,dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[ alt_names ]
DNS.0 = localhost
DNS.1 = vault
```
Создаем заявление на подпись
```
openssl req -config vault-gke-csr.cnf -new -key vault.key -nodes -out vault.csr
```
Переводим в base64, убираем перевод строк
```
export BASE64_CRS=$(cat ./vault.csr | base64 | tr -d '\n')
```
Создаем манифест:
```
cat <<EOF >vault-csr.yaml
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: vaultcsr
spec:
  groups:
  - system:authenticated
  request: ${BASE64_CRS}
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF
```
Создаем реквест:
```
kubectl apply -f vault-csr.yaml
```
Апрувим выдачу:
```kubectl certificate approve vaultcsr```
Вытаскиваем сертификат и записываем его в фаил:
```
kubectl get csr vaultcsr -o jsonpath='{.status.certificate}' | base64 --decode > vault.crt
```
Создаем секрет:
```
kubectl create secret generic vault --from-file=vault.key=vault.key --from-file=vault.crt=vault.crt
```
В vault-helm обновляем values.yaml
```
  extraEnvironmentVars:
    VAULT_ADDR: https://localhost:8200
    VAULT_CACERT: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```
```
  extraVolumes:
    - type: secret
      name: vault
      path: null
```
```
  config: |
      ui = true

      listener "tcp" {
        tls_disable = 0
        address = "[::]:8200"
        cluster_address = "[::]:8201"
        tls_cert_file = "/vault/userconfig/vault/vault.crt"
        tls_key_file  = "/vault/userconfig/vault/vault.key"      
      }
```
Пришлось прибить поды волта и сделать еще раз unseal
```
/ # VAULT_ADDR=https://vault:8200
/ # VAULT_CACERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
/ # KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token
/ # TOKEN=$(curl -k -s --request POST --data '{"jwt": "'$KUBE_TOKEN'", "role": "otus"}' $VAULT_ADDR/v1/auth/kubernetes/login | jq '.auth.client_token' | awk -F\" '{print $2}')
/ # echo $TOKEN
s.b8FGTHb2A9UD4Jk4iwD06aES
/ # curl --cacert $VAULT_CACERT --header "X-Vault-Token:s.b8FGTHb2A9UD4Jk4iwD06aES" $VAULT_ADDR/v1/otus/otus-ro/config | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   207  100   207    0     0   6900      0 --:--:-- --:--:-- --:--:--  6900
{
  "request_id": "54944a1b-01be-3fe1-a5f5-8fd2449d0a05",
  "lease_id": "",
  "renewable": false,
  "lease_duration": 2764800,
  "data": {
    "password": "asajkjkahs",
    "username": "otus"
  },
  "wrap_info": null,
  "warnings": null,
  "auth": null
}
```

12. Обновление сертификатов у Nginx
Добавили по фаил политики otus-policy.hcl
```
path "pki_int*" {
capabilities = ["read", "update", "create", "list", "sudo", "delete"]
}

path "pki*" {
capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
```
Создали и применили configmap для nginx configmap_nginx.yaml:
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  ssl.conf: |
    server {
        listen 443 ssl;
        server_name  localhost;
        ssl_certificate /etc/nginx/certs/tls.crt;
        ssl_certificate_key /etc/nginx/certs/tls.key;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }
    }
```
Скопировал фаил configmap.yaml в configmap_nginx_files.yaml, добавил темплейты для создания сертификатов внутри пода
```

    template {
    destination = "/etc/secrets/ca.crt"
    contents = "{{ with secret \"pki_int/issue/example-dot-ru\" \"common_name=nginx.example.ru\" \"ttl=24h\" }}{{ .Data.issuing_ca }}{{ end }}"
    }
    template {
    destination = "/etc/secrets/tls.key"
    contents = "{{ with secret \"pki_int/issue/example-dot-ru\" \"common_name=nginx.example.ru\" \"ttl=24h\" }}{{ .Data.private_key }}{{ end }}"
    }
    template {
    destination = "/etc/secrets/tls.crt"
    contents = "{{ with secret \"pki_int/issue/example-dot-ru\" \"common_name=nginx.example.ru\" \"ttl=24h\" }}{{ .Data.certificate }}{{ end }}"
    }
```
Создал фаил nginx-ssl.yaml
Применил все манифесты
![](kubernetes-vault/ssl1.JPG)
![](kubernetes-vault/ssl2.JPG)


## ДЗ: 24

## установка используя kubespray

1. Склонировал репозиторий
2. Установил зависимости
3. Скопировал конфиги
```
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
sudo pip install -r requirements.txt
cp -rfp inventory/sample inventory/mycluster
```
4. Отредактировал фаил [inventory.ini](kubernetes-production-clusters/kubespray/inventory/mycluster/inventory.ini)
5. Запустил установку
```ansible-playbook -i inventory/mycluster/inventory.ini --become --become-user=root cluster.yml -v --private-key=~/.ssh/gcloud -u ubuntu -e kube_version=v1.18.5```
```
# kubectl get nodes
NAME      STATUS   ROLES    AGE   VERSION
master1   Ready    master   13m   v1.18.5
master2   Ready    master   13m   v1.18.5
master3   Ready    master   13m   v1.18.5
node1     Ready    <none>   11m   v1.18.5
node2     Ready    <none>   11m   v1.18.5
```
## обновление
```ansible-playbook -i inventory/mycluster/inventory.ini --become --become-user=root upgrade-cluster.yml -v --private-key=~/.ssh/gcloud -u ubuntu -e kube_version=v1.19.2```
```
NAME      STATUS                     ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
master1   Ready,SchedulingDisabled   master   18m   v1.19.2   10.2.0.11     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
master2   Ready                      master   18m   v1.18.5   10.2.0.12     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
master3   Ready                      master   18m   v1.18.5   10.2.0.13     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
node1     Ready                      <none>   16m   v1.18.5   10.2.0.21     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
node2     Ready                      <none>   16m   v1.18.5   10.2.0.22     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
```
```
NAME      STATUS                     ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
master1   Ready                      master   21m   v1.19.2   10.2.0.11     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
master2   Ready,SchedulingDisabled   master   21m   v1.18.5   10.2.0.12     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
master3   Ready                      master   21m   v1.18.5   10.2.0.13     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
node1     Ready                      <none>   20m   v1.18.5   10.2.0.21     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
node2     Ready                      <none>   20m   v1.18.5   10.2.0.22     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
```
```
NAME      STATUS                     ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
master1   Ready                      master   29m   v1.19.2   10.2.0.11     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
master2   Ready                      master   28m   v1.19.2   10.2.0.12     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
master3   Ready                      master   28m   v1.19.2   10.2.0.13     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
node1     Ready,SchedulingDisabled   <none>   27m   v1.18.5   10.2.0.21     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
node2     Ready                      <none>   27m   v1.18.5   10.2.0.22     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
```
```
NAME      STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
master1   Ready    master   33m   v1.19.2   10.2.0.11     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
master2   Ready    master   32m   v1.19.2   10.2.0.12     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
master3   Ready    master   32m   v1.19.2   10.2.0.13     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
node1     Ready    <none>   31m   v1.19.2   10.2.0.21     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
node2     Ready    <none>   31m   v1.19.2   10.2.0.22     <none>        Ubuntu 18.04.5 LTS   5.4.0-1024-gcp   docker://19.3.13
```
