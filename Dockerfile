FROM node:10 AS builder

WORKDIR /app

COPY package*.json /app/

RUN npm install

# Generate third-party licenses file
FROM node:10 AS licenses
WORKDIR /app
COPY --from=builder /app/node_modules /app/node_modules
RUN npm install license-extractor
RUN node_modules/license-extractor/bin/licext --mode output > /app/LICENSE.thirdparties.txt


FROM node:10

WORKDIR /app

COPY --from=builder /app/node_modules /app/node_modules

COPY . /app/

# Extract licenses
COPY --from=licenses /app/LICENSE.thirdparties.txt /app/LICENSE.thirdparties.txt
