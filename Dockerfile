FROM node:20

RUN apt-get update -y
RUN apt-get upgrade -y


RUN apt-get install curl gnupg -y \
  && curl --location --silent https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install google-chrome-stable -y --no-install-recommends

RUN ls /usr/bin/

COPY --chown=node:node package*.json ./
COPY --chown=node:node app.js ./

RUN npm install --frozen-lockfile

EXPOSE 80
CMD ["node","app.js"]
