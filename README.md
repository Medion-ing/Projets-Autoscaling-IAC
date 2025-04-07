# AutoScaling et Infrastructure as Code (IaC) README

Le projet **AutoScaling et Infrastructure as Code (IaC)** consiste à déployer une infrastructure modulaire et évolutive pour un projet **redis-nodejs** utilisant Kubernetes et Docker. L'objectif est de permettre à chaque composant de l'infrastructure (Redis, Node.js, React, Prometheus/Grafana) de s'ajuster dynamiquement en fonction de la charge, tout en assurant une surveillance à l’aide de **Prometheus** et **Grafana**.

## Structure du répertoire

Le répertoire contient les fichiers suivants pour déployer et configurer les différentes parties de l'application :

- **frontend-deployment.yml** : Déploiement du frontend basé sur une image Docker `redis-react-frontend`.
- **frontend-service.yml** : Service Kubernetes exposant le frontend via un port `NodePort`.
- **node-redis-deployment.yml** : Déploiement de l'application `node-redis` exposant un serveur Node.js sur le port 8080.
- **node-redis-service.yml** : Service Kubernetes exposant le service Node.js via un port `NodePort`.
- **redis-deployment.yml** : Déploiement du service Redis principal avec une image `redis:7.2`.
- **redis-service.yml** : Service Kubernetes exposant Redis sur le port 6379 via `ClusterIP`.
- **redis-exporter-deployment.yml** : Déploiement du Redis Exporter pour la surveillance de Redis.
- **redis-exporter-service.yml** : Service Kubernetes exposant Redis Exporter pour la collecte des métriques.
- **redis-replicas-service.yml** : Service Kubernetes pour exposer les réplicas de Redis.
- **redis-replicas-statefulset.yml** : StatefulSet Kubernetes pour gérer les réplicas Redis dans une architecture de réplicas maître-esclave.
- **prometheus-deployment.yml** : Déploiement de Prometheus pour la collecte des métriques système.
- **grafana-deployment.yml** : Déploiement de Grafana pour visualiser les métriques collectées par Prometheus.
- **hpa.yml** : Définition des Horizontal Pod Autoscalers pour les déploiements `node-redis` et les réplicas de Redis.
- **kube-state-metrics-deployment.yml** : Déploiement du `kube-state-metrics`, permettant d'exposer des métriques détaillées de l'état de Kubernetes pour la surveillance.
- **metrics-server.yaml** : Déploiement du serveur de métriques Kubernetes pour la collecte des ressources utilisées.
- **clusterrolebinding.yml** : Rôle de liaison pour donner les permissions nécessaires à certains services.
- **clusterrole.yml** : Définition des rôles Kubernetes pour les accès aux ressources.
- **serviceaccount.yml** : Compte de service pour l'exécution des pods avec des permissions spécifiques.

## Description des composants

1. **Frontend** 
   Le frontend est une application React qui se connecte à un serveur Node.js exposé sur le port `80`. Il utilise une variable d'environnement `API_URL` pointant vers `http://node-redis:8080` pour accéder aux données.
   Source : [`redis-react`](https://github.com/arthurescriou/redis-react) 
   Image utilisée : `redis-react-frontend`


2. **Node-Redis** 
   Cette application Node.js expose un serveur sur le port `8080`, se connecte à Redis pour récupérer les données et fournit une API RESTful.
   Source : [`redis-node`](https://github.com/arthurescriou/redis-node) 
   Image utilisée : `redis-node-server`

3. **Redis** 
   Redis est déployé en tant que service principal sur le port `6379`. Il fournit un cache de données et une base de données clé-valeur pour l'application.
   Image utilisée : [`redis`](https://hub.docker.com/_/redis)

4. **Redis Exporter** 
   Le Redis Exporter est utilisé pour collecter des métriques sur l'état de Redis et les exposer via un endpoint HTTP sur le port `9121`.

5. **Redis Replicas** 
   Un StatefulSet est utilisé pour déployer des réplicas de Redis, avec une architecture de réplication maître-esclave pour assurer la haute disponibilité et la tolérance aux pannes.

6. **Prometheus** 
   Prometheus est utilisé pour collecter des métriques des différentes ressources Kubernetes et des applications.
   Image utilisée: [`prom/prometheus`](https://hub.docker.com/r/prom/prometheus) 

7. **Grafana** 
   Grafana est utilisé pour visualiser les métriques collectées par Prometheus dans un tableau de bord interactif.
   Image utilisée: [`grafana/grafana`](https://hub.docker.com/r/grafana/grafana)

## Déploiement

### Prérequis

- Kubernetes cluster (minikube)
- `kubectl` configuré pour accéder au cluster

### Étapes d'installation

1. **Déployer les ressources** 

   # 1. Démarrer minikube
   ```bash
   minikube start
   
   Appliquez chaque fichier YAML pour déployer les ressources dans votre cluster Kubernetes :
   ```bash
   kubectl apply -f frontend-deployment.yml
   kubectl apply -f frontend-service.yml
   kubectl apply -f node-redis-deployment.yml
   kubectl apply -f node-redis-service.yml
   kubectl apply -f redis-deployment.yml
   kubectl apply -f redis-service.yml
   kubectl apply -f redis-exporter-deployment.yml
   kubectl apply -f redis-exporter-service.yml
   kubectl apply -f redis-replicas-service.yml
   kubectl apply -f redis-replicas-statefulset.yml
   kubectl apply -f prometheus-deployment.yml
   kubectl apply -f grafana-deployment.yml
   kubectl apply -f hpa.yml
   kubectl apply -f kube-state-metrics-deployment.yml
   kubectl apply -f metrics-server.yaml
   kubectl apply -f clusterrolebinding.yml
   kubectl apply -f clusterrole.yml
   kubectl apply -f serviceaccount.yml
   ```

## Vérifier les déploiements

Une fois que toutes les ressources ont été déployées, vous pouvez vérifier l'état de vos déploiements et services avec la commande suivante :

```bash
kubectl get all
```

Pour les ressources dans un namespace(dans notre cas, le namespace est **default**) spécifique :

```bash
kubectl get all --namespace <nom_du_namespace>
```

## Accéder aux services

### Prometheus

```bash
kubectl port-forward svc/prometheus 9090:9090
```
Puis ouvrez dans votre navigateur : http://localhost:9090

### Grafana

```bash
minikube ip
```
Puis ouvrez dans votre navigateur : http://<adresse_ip_minikube>:3000 
Par défaut : utilisateur `admin`, mot de passe `admin`

### Node.js

```bash
kubectl port-forward svc/node-redis 8080:8080
```
Puis ouvrez dans votre navigateur : http://localhost:8080

### Frontend

```bash
minikube ip
```
Puis ouvrez dans votre navigateur : http://<adresse_ip_minikube>:<port_du_frontend>

## Surveillance et métriques

- **Prometheus** collecte les métriques via ses endpoints (http://localhost:9090).
- **Grafana** permet de visualiser les métriques de Redis, Node.js et Kubernetes (http://<adresse_ip_minikube>:3000).

Vous pouvez créer ou importer des tableaux de bord pour visualiser l'état et les performances de votre cluster.
