FROM node:14
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install npm packages including dev dependencies
RUN npm install

COPY dist .

RUN npm run build

EXPOSE 8081

CMD [ "npm", "start" ]
