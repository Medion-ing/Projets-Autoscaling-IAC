#!/bin/bash

# ============================================
# Script de déploiement automatisé Kubernetes
# Projet : AutoScaling et IaC (redis-nodejs)
# ============================================

echo "📦 Démarrage du déploiement de l'infrastructure..."

# 1. Appliquer les rôles et comptes nécessaires
echo "🔐 Déploiement des rôles et comptes de service..."
kubectl apply -f clusterrole.yml
kubectl apply -f clusterrolebinding.yml
kubectl apply -f serviceaccount.yml

# 2. Installer le serveur de métriques (utile pour l'autoscaling)
echo "📊 Déploiement du serveur de métriques..."
kubectl apply -f metrics-server.yaml

# 3. Déploiement des composants de monitoring
echo "📡 Déploiement de kube-state-metrics..."
kubectl apply -f kube-state-metrics-rbac.yml
kubectl apply -f kube-state-metrics-deployment.yml

echo "📈 Déploiement de Prometheus..."
kubectl apply -f prometheus-deployment.yml

echo "📉 Déploiement de Grafana..."
kubectl apply -f grafana-deployment.yml

# 4. Déploiement de Redis principal et Redis Exporter
echo "🗄️ Déploiement de Redis..."
kubectl apply -f redis-deployment.yml
kubectl apply -f redis-service.yml

echo "📦 Déploiement du Redis Exporter..."
kubectl apply -f redis-exporter-deployment.yml
kubectl apply -f redis-exporter-service.yml

# 5. Déploiement des réplicas Redis
echo "🧬 Déploiement des réplicas Redis..."
kubectl apply -f redis-replicas-service.yml
kubectl apply -f redis-replicas-statefulset.yml

# 6. Déploiement de l'application Node.js
echo "🖥️ Déploiement du backend Node.js..."
kubectl apply -f node-redis-deployment.yml
kubectl apply -f node-redis-service.yml

# 7. Déploiement du frontend React
echo "🌐 Déploiement du frontend React..."
kubectl apply -f frontend-deployment.yml
kubectl apply -f frontend-service.yml

# 8. Application des règles d'autoscaling
echo "📈 Application des Horizontal Pod Autoscalers..."
kubectl apply -f hpa.yml

echo "✅ Déploiement terminé !"
echo "💡 Vérifiez les ressources avec : kubectl get all"
