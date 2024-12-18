# Base image
FROM node:20

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN pnpm install

# Copy app source code
COPY . .

# Expose port (e.g., 3000)
EXPOSE 5173

# Start the application
CMD ["pnpm", "run", "dev"]

