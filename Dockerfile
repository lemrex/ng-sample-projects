# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json first for better caching
COPY package.json ./

# Remove package-lock.json (if needed) and regenerate it
RUN rm -f package-lock.json && npm install --package-lock-only

# Copy the rest of the application files
COPY . .

# Install dependencies
RUN npm install --omit=dev

# Expose application port
EXPOSE 3000

# Command to run the app
CMD ["npm", "start"]
