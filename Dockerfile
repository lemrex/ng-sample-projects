# Use Node.js LTS as the base image
FROM node:lts AS build

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies using npm ci with caching
RUN npm ci --cache .npm --prefer-offline

# Copy the rest of the app files
COPY . .

# Verify Angular installation
RUN npx ng version

# Build the Angular application using npm
RUN npm run build

# Serve the Angular app using Nginx
FROM nginx:alpine

# Set working directory in nginx
WORKDIR /usr/share/nginx/html

# Remove default nginx static files
RUN rm -rf ./*

# Copy built Angular app from previous stage
COPY --from=build /app/dist .

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]




































