# Web server base image
FROM nginx:alpine

# Copy the HTMX frontend files to the container
COPY . /usr/share/nginx/html

# Expose the port that Nginx will listen on
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]