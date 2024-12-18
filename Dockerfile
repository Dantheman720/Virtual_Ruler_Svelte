# Base image
FROM node:20

# Install pnpm globally
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies using pnpm
RUN pnpm install

# Copy app source code
COPY . .

# Expose port (e.g., 5173 for Vite)
EXPOSE 5173

# Start the application
CMD ["pnpm", "run", "dev"]

