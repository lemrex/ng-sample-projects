# # Use an official Node.js runtime as a parent image
# FROM node:18-alpine

# # Set the working directory
# WORKDIR /app

# # Copy package.json and package-lock.json first for better caching
# COPY package.json ./

# # Remove package-lock.json (if needed) and regenerate it
# RUN rm -f package-lock.json && npm install --package-lock-only

# # Copy the rest of the application files
# COPY . .

# # Install dependencies
# RUN npm install --omit=dev

# # Expose application port
# EXPOSE 3000

# # Command to run the app
# CMD ["npm", "start"]

# Stage 1: Build the Angular application
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package files and regenerate package-lock.json
COPY package.json package-lock.json ./
RUN rm -f package-lock.json && npm install --package-lock-only

# Install dependencies
RUN npm install

# Copy the rest of the app and build it
COPY . .
RUN npm run build

# Stage 2: Serve the app using Nginx
FROM nginx:alpine

# Set working directory to Nginx's default static file serving location
WORKDIR /usr/share/nginx/html

# Remove default Nginx static files
RUN rm -rf ./*

# Copy built Angular app from Stage 1
COPY --from=build /app/dist/ng-sample-projects ./

# Expose the port Nginx runs on
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
