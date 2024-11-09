FROM node:20.15.1-slim

# Install OpenSSL
RUN apt-get update && apt-get install -y openssl

WORKDIR /app
COPY . .

# Generate RSA keys
RUN mkdir -p keys && \
    openssl genpkey -algorithm RSA -out keys/private.pem -pkeyopt rsa_keygen_bits:2048 && \
    openssl rsa -pubout -in keys/private.pem -out keys/public.pem

HEALTHCHECK --interval=300s --timeout=30s --start-period=5s --retries=3 CMD [ "node", "healthy-check.js" ]
RUN npm install -g pnpm && pnpm install
EXPOSE 8000
ENTRYPOINT [ "npm", "start" ]
