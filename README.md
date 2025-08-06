# 📱 2025 A2SV G6 Mobile Assessment

This repository contains the final mobile assessment project for **A2SV Group 6 (2025)**. The assessment focuses on implementing **authentication** and **real-time chat** features using **Flutter**, following clean architecture and best practices.

## 🚀 Features

### 🔐 Authentication
- Sign In and Sign Out functionality
- Secure session management
- Welcome screen based on Figma design

### 💬 Real-Time Chat
- Chat list screen displaying conversations
- One-to-one chat interface
- Real-time messaging using `socket_io_client`
- Socket events: `message:send`, `message:received`, `message:delivered`
- Message status updates and live UI feedback

## 🧱 Tech Stack

- **Flutter** (with Clean Architecture)
- **Socket.IO** for real-time messaging
- **State Management:** (e.g., BLoC, Riverpod – depending on implementation)
- **Dart** language
- **Secure Storage** for auth tokens

## 📁 Folder Structure (Example)

```

lib/
├── core/
├── features/
│   ├── auth/
│   └── chat/
├── presentation/
├── data/
└── domain/

```
