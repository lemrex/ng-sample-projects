



FROM node:20.14.0-alpine3.20 AS build



WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .



RUN npm run build
# Stage 2: Serve the app with Nginx
FROM nginx:latest

# Copy nginx config
COPY --from=build /app/nginx.conf /etc/nginx/nginx.conf

# Copy built files from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
