# Node redis server

## Install dependencies

```sh
npm install
# OR
yarn
```

## Run server

```sh
node main.js
```

## Environment variable

Default values :

```
REDIS_URL='redis://localhost:6379'
REDIS_REPLICAS_URL=REDIS_URL # read only redis node
PORT=3000
```
