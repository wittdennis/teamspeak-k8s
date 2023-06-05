# Teamspeak Server

This repository contains manifest files to run a [TeamSpeak](https://www.teamspeak.com/) server inside a Kubernetes cluster.

## Requirements

The Teamspeak Server is configured to use a [MariaDB](https://mariadb.org/) as backend database technology. The mariadb is configured using [mariadb-operator](https://github.com/mariadb-operator/mariadb-operator) which has to be installed in the cluster.

There are also some prometheus monitoring configured so the [prometheus-operator](https://github.com/prometheus-operator/prometheus-operator) is also required.

## Usage

To setup the server set the storage classes for the mariadb instance and your Teamspeak server.

mariadb (manifests/database/mariadb):

```yaml
  ...

  volumeClaimTemplate:
    resources:
      requests:
        storage: 10Gi
    storageClassName: <your_storage_class>
    accessModes:
      - ReadWriteOnce
  volumes:
    - name: tmp
      emptyDir: {}
  volumeMounts:
    - name: tmp
      mountPath: /tmp

  ...
```

Teamspeak (manifests/teamspeak/ts-data-pvc.yaml):

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  labels:
    app: teamspeak
    project: teamspeak
  name: ts-data
  namespace: teamspeak
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: <your_storage_class>
```

You also have to create some secrets that will be used by mariadb and teamspeak that must be present. You can create them by running these commands:

```sh
kubectl create secret generic root.user.teamspeak.mariadb --from-literal=password=<MARIADB_ROOT_PASSWORD>
kubectl create secret generic teamspeak.user.teamspeak.mariadb --from-literal=username=teamspeak --from-literal=password=<TEAMSPEAK_USER_PASSWORD>
```

After that run:

```sh
kubectl apply -f manifests/database
kubectl apply -f manifests/teamspeak
```

In order to get teamspeak metrics you have to set another secret with the password for the serveradmin of your created Teamspeak server. You can retrieve this from the logs of the started server. After that set the following secret:

```
kubectl create secret generic teamspeak-metrics-user --from-literal=username=serveradmin --from-literal=password=<TEAMSPEAK_SERVERADMIN_PASSWORD>
```
