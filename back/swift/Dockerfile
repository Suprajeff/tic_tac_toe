# Use the official Swift image as the base image
FROM swift:latest

# Set the working directory in the container
WORKDIR /app

# Copy package.swift
COPY Package*.swift ./

# Resolve dependencies
RUN swift package resolve

# Copy the Swift files into the container
COPY . .

# Build the Vapor app
RUN swift build

# Expose the port Vapor will run on
EXPOSE 8083

# Start Vapor app
CMD swift run

