FROM node:22-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY hardhat.config.ts tsconfig.json ./
COPY contracts/ contracts/
COPY scripts/ scripts/
COPY test/ test/

RUN npx hardhat compile

CMD ["npx", "hardhat", "run", "scripts/crear-titulo.ts"]