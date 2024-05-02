import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    kotlin("jvm") version "1.5.31"
    application
    kotlin("plugin.serialization") version "1.5.31"
}

group = "com.supralata"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.ktor:ktor-server-core:1.6.8")
    implementation("io.ktor:ktor-server-netty:1.6.8")
    implementation("io.ktor:ktor-websockets:1.6.8")
    implementation("io.lettuce:lettuce-core:6.3.2.RELEASE")
    testImplementation("org.jetbrains.kotlin:kotlin-test:1.5.31")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.3.2")
}

tasks.withType<KotlinCompile> {
    kotlinOptions.jvmTarget = "11"
}

application {
    mainClassName = "app/appKt"
}

kotlin {
    sourceSets.main {
        kotlin.srcDirs("app")
    }
}

tasks.jar {
    manifest {
        attributes("Main-Class" to "app.AppKt")
    }
    from(configurations.runtimeClasspath.get().map { if (it.isDirectory) it else zipTree(it) })
}

