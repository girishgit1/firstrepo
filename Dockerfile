# Use the official Node.js image as a base
FROM node:14

# Copy the Node.js script into the container
COPY hello_world.js /app/hello_world.js

# Set the working directory
WORKDIR /app

# Run the Node.js script when the container starts
CMD ["node", "hello_world.js"]
