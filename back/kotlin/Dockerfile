# Use an OpenJDK base image
FROM openjdk:12-jdk-alpine

# Set the working directory
WORKDIR /app

# Install Kotlin
# ENV KOTLIN_VERSION 1.5.31
ENV KOTLIN_VERSION 1.8.0
RUN wget -O kotlin-compiler.zip "https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-compiler-${KOTLIN_VERSION}.zip" && \
    unzip kotlin-compiler.zip -d /opt && \
    rm kotlin-compiler.zip

# Add kotlinc to PATH
ENV PATH $PATH:/opt/kotlinc/bin

# Copy Kotlin Standard Library to a known location
RUN cp /opt/kotlinc/lib/kotlin-stdlib.jar /app/kotlin-stdlib.jar

# Install Gradle
ENV GRADLE_VERSION 8.7
RUN wget -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
    unzip gradle.zip -d /opt && \
    rm gradle.zip

# Add Gradle to PATH
ENV PATH $PATH:/opt/gradle-${GRADLE_VERSION}/bin

# Copy Gradle files - no settings.gradle.kts
COPY build.gradle.kts ./

# Initialize Gradle Wrapper
RUN /opt/gradle-${GRADLE_VERSION}/bin/gradle wrapper

# Set execute permission for Gradle Wrapper
RUN chmod +x ./gradlew

# Download Gradle and dependencies
RUN ./gradlew --no-daemon dependencies

# Copy files into container
COPY . .

# Build Kotlin App
RUN ./gradlew --no-daemon jar

EXPOSE 8082

# Start App
CMD ["java", "-jar", "build/libs/tic-tac-toe-1.0.0.jar"]
# CMD ["./gradlew", "--no-daemon", "run"]


