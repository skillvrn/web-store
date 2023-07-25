# Build
FROM node:16-alpine as builder
WORKDIR /app
COPY . .
RUN npm install && NODE_ENV=production VUE_APP_API_URL=/api npm run build

# Release
FROM nginx:1.25.1
COPY --from=builder /app/dist /usr/share/nginx/html
