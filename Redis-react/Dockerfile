# Utilise l'image officielle Nginx comme base
FROM nginx:alpine

# Copie les fichiers générés par `yarn build` dans le répertoire Nginx
COPY build/ /usr/share/nginx/html

# Expose le port 80
EXPOSE 80

# Démarre Nginx
CMD ["nginx", "-g", "daemon off;"]

