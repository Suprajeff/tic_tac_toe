# Use an OpenJDK base image
FROM openjdk:11-jdk

# Set the working directory
WORKDIR /app

# Install Kotlin
ENV KOTLIN_VERSION 1.5.31
RUN wget -O kotlin-compiler.zip "https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip" && \
    unzip kotlin-compiler.zip -d /opt && \
    rm kotlin-compiler.zip

# Add kotlinc to PATH
ENV PATH $PATH:/opt/kotlinc/bin

# Debug: List contents before copy
RUN ls -al /opt/kotlinc/lib/

# Copy Kotlin Standard Library to a known location
RUN cp /opt/kotlinc/lib/kotlin-stdlib.jar /app/kotlin-stdlib.jar

# Debug: List contents after copy
RUN ls -al /app/

# Copy files into container
COPY . .

