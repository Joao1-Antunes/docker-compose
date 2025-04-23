FROM node:20 AS build

WORKDIR /usr/src/app 

COPY package*.json ./ 
RUN npm install

COPY . . 

RUN npm run build
ENV NODE_ENV=production
RUN npm ci && npm cache clean --force

FROM node:20-alpine 

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules 

EXPOSE 3000 

CMD ["npm", "run", "start:prod"]