FROM node:20

# Mise à jour du système et installation des dépendances
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg lsb-release

# Ajouter le dépôt Debian pour Chromium
RUN echo "deb http://deb.debian.org/debian/ stable main contrib" > /etc/apt/sources.list.d/debian.list \
    && apt-get update

# Installer Chromium
RUN apt-get install -y --no-install-recommends chromium \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Vérification de l'installation
RUN ls /usr/bin/

# Copier les fichiers nécessaires
COPY --chown=node:node package*.json ./
COPY --chown=node:node app.js ./

# Installer les dépendances du projet
RUN npm install --frozen-lockfile

# Exposer le port 80
EXPOSE 80

# Commande pour démarrer l'application
CMD ["node", "app.js"]
