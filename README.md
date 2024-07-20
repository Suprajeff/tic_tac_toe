![Kotlin](https://img.shields.io/badge/Kotlin-7F52FF.svg?&style=flat&logo=kotlin&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-FA7343?style=flat-square&logo=swift&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6.svg?&style=flat&logo=typescript&logoColor=white)
![Go](https://img.shields.io/badge/Go-00ADD8?style=flat-square&logo=go&logoColor=white)

Tic Tac Toe HTMX App
====================

This repository showcases, via this classic implementation of the tic-tac-toe game, an htmx application built with four different backend languages: Go, TypeScript, Kotlin, and Swift. The application maintains a consistent user interface and functionality across all backends and demonstrates the simplicity of htmx, a powerful library that enables developers to create high-performance, modern web applications by seamlessly integrating HTML and server-side technologies. The codebase serves as a valuable reference for developers exploring htmx or seeking to integrate it with various backend stacks, highlighting the framework's language-agnostic nature and its ability to facilitate efficient development across multiple platforms.

## **Development Environment / Deployment**

To facilitate easy deployment and ensure consistency across different environments, this project leverages Docker containerization. Each of the four backend implementations (Express for Node.js, Gorilla for Go, Vapor for Swift, and Ktor for Kotlin) is packaged within its own Docker container, ensuring seamless portability and reproducibility.

## **Architecture**

This application adheres to the principles of Clean Architecture, employing a vertical, layered structure organized by features and utilizing Object-Oriented Programming (OOP). The codebase is modularized into self-contained feature modules, each encapsulating its own domain logic, use cases, and infrastructure concerns. This architectural approach, combined with OOP principles, promotes separation of concerns, enhancing code maintainability, testability, and extensibility.
