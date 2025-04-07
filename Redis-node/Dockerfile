# Utilisation de l’image Node.js officielle
FROM node:18

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires
COPY package.json yarn.lock ./

# Installer les dépendances
RUN yarn install

# Copier le reste du projet
COPY . .

# Exposer le port d'écoute
EXPOSE 3000

# Définir l’URL de Redis dans Docker
ENV REDIS_URL=redis://redis:6379

# Démarrer l'application
CMD ["node", "main.js"]
