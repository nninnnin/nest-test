# Building Layer
FROM node:16-alpine as development

WORKDIR /app

# Copy configration files
COPY tsconfig*.json ./
COPY package*.json ./

# Install dependencies from package-lock.json
RUN npm ci

# Copy application sources (.ts, .tsx, .js)
COPY src/ src/

# Build application (produces dist/ folder)
RUN npm run build

# Runtime(production) Layer
FROM node:16-alpine as production

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

# Copy production build
COPY --from development /app/dist ./dist/

# Expose application port
EXPOSE 8000

# Start application
CMD ["node", "dist/main.js"]
