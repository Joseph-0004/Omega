# Image de base légère avec Nginx
FROM nginx:alpine

# Copier le fichier HTML dans le répertoire web de Nginx
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]