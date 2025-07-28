# Use official Node.js image
FROM node:18

# Set working directory
WORKDIR /app

# Copy index.html from app/ directory
COPY app/index.html .

# Install express
RUN npm init -y && npm install express

# Create simple express server to serve index.html
RUN echo "const express = require('express'); \
const app = express(); \
const path = require('path'); \
app.use(express.static(__dirname)); \
app.get('/', (req, res) => res.sendFile(path.join(__dirname, 'index.html'))); \
app.listen(3000, () => console.log('App running on port 3000'));" > server.js

# Expose port
EXPOSE 3000

# Run the server
CMD ["node", "server.js"]
