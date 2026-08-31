# Base Image
FROM node:22-alpine

# Working Directory
WORKDIR /app

# Copy (dependency files) package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Expose backend port
EXPOSE 5000

# Start the application
CMD ["npm", "start"]
