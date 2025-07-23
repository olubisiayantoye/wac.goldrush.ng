# 1. Base Image: Use Node.js 20 LTS to meet dependency requirements.
# 'slim' is a good balance of size and functionality.
FROM node:20-slim

# 2. Install System Dependencies
# These are all the packages we discovered we need through debugging.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    git \
    openssh-client \
    ca-certificates \
    libwebp-dev \
    libpng-dev \
    libjpeg-dev \
    libgif-dev \
    # Clean up apt cache to keep the image smaller
    && rm -rf /var/lib/apt/lists/*

# 3. Set the working directory inside the container
WORKDIR /app

# 4. Copy package files
COPY package*.json ./

# 5. Force Git to use HTTPS instead of SSH for GitHub dependencies
# This prevents the "Permission denied (publickey)" error.
RUN git config --global url."https://github.com/".insteadOf ssh://git@github.com/

# 6. Install dependencies
# This will now run in a Node.js 20 environment.
RUN npm install

# 7. Copy the rest of your application code into the container
COPY . .

# 8. Expose the port your application runs on
# This MUST match the port your application listens on (8001).
EXPOSE 8001

# 9. Define the command to start your application
# This uses the "start" script from your package.json.
CMD ["npm", "start"]
