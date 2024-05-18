import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    application
    kotlin("jvm") version "1.8.0"
    kotlin("plugin.serialization") version "1.8.0"
}

group = "com.supralata"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.ktor:ktor-server-core:2.3.11")
    implementation("io.ktor:ktor-server-cors:2.3.11")
    implementation("io.ktor:ktor-server-sessions:2.3.11")
    implementation("io.ktor:ktor-server-netty:2.3.11")
    implementation("io.ktor:ktor-server-content-negotiation:2.3.11")
    implementation("io.ktor:ktor-serialization-kotlinx-json:2.3.11")
    implementation("ch.qos.logback:logback-classic:1.4.14")
    implementation("io.ktor:ktor-websockets:2.3.11")
    implementation("io.lettuce:lettuce-core:6.3.2.RELEASE")
    testImplementation("org.jetbrains.kotlin:kotlin-test:1.8.0")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.3.2")
}

tasks.withType<KotlinCompile> {
    kotlinOptions.jvmTarget = "12"
}

application {
    mainClass.set("AppKt")
}

kotlin {
    sourceSets.main {
        kotlin.srcDirs("app")
    }
}

tasks.jar {
    archiveBaseName.set("tic-tac-toe")
    version = "1.0.0"
}



//tasks.jar {
//    manifest {
//        attributes("Main-Class" to "app.AppKt")
//    }
//    from(configurations.runtimeClasspath.get().map { if (it.isDirectory) it else zipTree(it) })
//}

