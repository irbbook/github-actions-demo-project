# Use the official Node.js 20 image as the base image
FROM node:20-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies using npm ci (for reproducible builds)
RUN npm ci

# Copy the entire project into the container
COPY . .

# Run tests to ensure everything is working before building
RUN npm test

# Build the app
RUN npm run build

# Use a smaller Node.js image for the runtime
FROM node:20-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the built app from the build stage
COPY --from=build /app .

# Expose application port (adjust if your app listens on another port)
EXPOSE 3000

# Start the application
CMD ["node", "dist/index.js"]
