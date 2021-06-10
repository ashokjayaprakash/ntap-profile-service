FROM node:16.3.0-slim as BUILD_IMAGE

COPY ./ singlelink/

WORKDIR singlelink

EXPOSE 80

RUN npm install typescript -g && npm install && npm run build

FROM node:16.3.0-slim

WORKDIR singlelink

COPY --from=BUILD_IMAGE /singlelink/dist ./dist
COPY --from=BUILD_IMAGE /singlelink/node_modules ./node_modules
COPY --from=BUILD_IMAGE /singlelink/package.json ./package.json
COPY --from=BUILD_IMAGE /singlelink/*.png ./

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

CMD npm run start
