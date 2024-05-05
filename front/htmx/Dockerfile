# Web server base image
FROM nginx:alpine

# Copy the HTMX frontend files to the container
COPY /app/index.html /usr/share/nginx/html

# Expose the port that Nginx will listen on
EXPOSE 8085