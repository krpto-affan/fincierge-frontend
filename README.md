# Fincierge
A design-driven AI-powered mobile application that combines a clean Flutter UI with a Retrieval-Augmented Generation (RAG) backend for contextual intelligent assistance.

## 📱 Demo APK

Download the latest release of the Fincierge Android app:

👉 **[Download Fincierge v1.0.0 APK](https://github.com/krpto-affan/fincierge-frontend/releases/tag/v1.0.0)**
> ⚠️ This is a demo APK. You may need to enable **Install from Unknown Sources** in your device settings to install it.


## Overview

Fincierge is a personal finance and AI assistance mobile application built with a focus on thoughtful UI/UX design and scalable system architecture. The app enables users to interact with an AI assistant, manage their profiles, and view conversation history through a secure and responsive interface.

The system follows a client–server architecture where a Flutter-based frontend communicates with a FastAPI backend. Firebase handles authentication and data storage, while a Retrieval-Augmented Generation (RAG) pipeline powered by FAISS and Gemini AI enables contextual and accurate responses.

## Key Features

- Clean and intuitive mobile UI designed in Figma and implemented in Flutter  
- Secure user authentication using Firebase  
- AI-powered chat assistant with contextual response generation  
- Retrieval-Augmented Generation (RAG) pipeline for improved accuracy  
- Vector-based semantic search using FAISS  
- User profile management and chat history storage  
- Offline connectivity detection and graceful error handling  
- Modular backend architecture for scalability and deployment flexibility
  
## Tech Stack

**Frontend**
- Flutter (Dart)
- Figma (UI/UX Design)

**Backend**
- FastAPI (Python)
- FAISS (Vector Search)
- Gemini AI API

**Cloud & Database**
- Firebase Authentication
- Firestore Database

**Tools**
- Git & GitHub
- REST APIs

## System Architecture

The application follows a client-server architecture:

1. Users interact with the Flutter mobile application.
2. Authentication and user data are managed through Firebase Authentication and Firestore.
3. User queries are sent to the FastAPI backend.
4. The backend converts queries into embeddings using Gemini.
5. FAISS retrieves relevant document chunks from the vector store.
6. Retrieved context is passed back to Gemini for response generation.
7. Responses are returned to the client and stored for history tracking.

This architecture enables scalable, modular development while maintaining secure data flow and low latency.

## UI Preview

<img width="360" height="800" alt="Get Started" src="https://github.com/user-attachments/assets/9b2f8753-8fde-4dba-ae8e-ea5fdfdc9814" />
<img width="360" height="800" alt="Onboarding Screen" src="https://github.com/user-attachments/assets/1fc05279-2b74-410e-b946-5b224b9d42b4" />
<img width="360" height="800" alt="Login" src="https://github.com/user-attachments/assets/271fa8a8-0cdf-4fcb-a74b-a9e5f0c761a2" />
<img width="360" height="800" alt="Create Account" src="https://github.com/user-attachments/assets/de5bb844-b095-46ef-9ba2-0625fe310c7c" />
<img width="360" height="800" alt="Chat Screen 5" src="https://github.com/user-attachments/assets/4b1c9401-21b0-4e90-a0a0-e19bec6fb4db" />

## Getting Started

### Prerequisites
- Flutter SDK installed
- Python 3.9+
- Firebase project setup
- Gemini API key

### Run Frontend
```bash
flutter pub get
flutter run

## Configuration

Sensitive configuration values such as API keys and Firebase credentials should not be committed to version control.

- Configure Firebase locally using your own project setup.
- Store API keys and secrets using environment variables or a `.env` file.
- Ensure `.gitignore` excludes sensitive configuration files.

Refer to Firebase and Gemini documentation for setup instructions.

## My Contribution

- Designed the complete UI/UX flow in Figma (~35 screens).
- Implemented the Flutter frontend and UI logic.
- Integrated backend APIs and handled client-server communication.
- Contributed to backend architecture and RAG pipeline integration.
- Focused on usability, visual consistency, and performance optimization.

This project was originally developed as a team academic project.

## License

This project is licensed under the MIT License.
