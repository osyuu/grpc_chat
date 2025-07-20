# gRPC Chat Application

A real-time chat application built with Dart gRPC server and Flutter client, demonstrating bidirectional streaming communication.

## 📁 Project Structure

```
grpc_chat/
├── backend/
│   └── chat_server/          # Dart gRPC server
├── frontend/
│   └── grpc_chat/            # Flutter client application
└── protos/
    └── chat.proto            # Protocol buffer definitions
```

## Installation & Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd grpc_chat
```

### 2. Generate Protocol Buffer Code

First, install the protoc compiler and Dart protobuf plugin:

```bash
# Install protoc (macOS)
brew install protobuf

# Install Dart protobuf plugin
dart pub global activate protoc_plugin
```

Generate the Dart code from the proto file:

```bash
# Generate server code
cd backend/chat_server
protoc --dart_out=lib/src/generated --grpc_out=lib/src/generated --proto_path=../../protos ../../protos/chat.proto google/protobuf/timestamp.proto

# Generate client code
cd frontend/grpc_chat
protoc --dart_out=lib/src/generated --grpc_out=lib/src/generated --proto_path=../../protos ../../protos/chat.proto google/protobuf/timestamp.proto
```

### 3. Environment Configuration

Create a `.env` file in the frontend directory:

```bash
cd frontend/grpc_chat
touch .env
```

Add the following content to `.env`:

```env
GRPC_HOST=localhost
GRPC_PORT=50051
```

## 🚀 Running the Application

### Start the Backend Server

```bash
cd backend/chat_server
dart run bin/chat_server.dart
```

### Start the Flutter Client

In a new terminal:

```bash
cd frontend/grpc_chat
flutter run
```

## 🔗 Related Resources

- [Dart gRPC Documentation](https://grpc.io/docs/languages/dart/)
- [Flutter Documentation](https://flutter.dev/docs)
- [Protocol Buffers Guide](https://developers.google.com/protocol-buffers)
- [Riverpod Documentation](https://riverpod.dev/)
