import 'dart:async';

import 'package:chat_server/src/generated/chat.pbgrpc.dart';
import 'package:chat_server/src/generated/google/protobuf/timestamp.pb.dart';
import 'package:grpc/grpc.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  final server = Server.create(
    services: [ChatServer()],
    codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  );

  await server.serve(port: 50051);

  print('Server listening on port ${server.port}...');
}

class ChatServer extends ChatServiceBase {
  final _controllers = <StreamController<Message>, void Function()?>{};
  final _messagesCache = <Message>[];

  @override
  Stream<Message> connect(ServiceCall call, Stream<Message> request) async* {
    // Send cached messages to the new client
    for (var message in _messagesCache) {
      yield message;
    }

    final clientController = StreamController<Message>();
    _controllers[clientController] = null;

    request.listen((request) {
      print('Connected: ${request.sender} #${request.hashCode}');
      // Assign a unique ID and timestamp to the message
      request.id = Uuid().v1();
      request.createdAt = Timestamp.fromDateTime(DateTime.now());

      if (_messagesCache.length >= 100) {
        _messagesCache
            .removeAt(0); // Remove the oldest message if cache is full
      }
      // Add the message to the cache
      _messagesCache.add(request);

      _controllers.forEach((controller, _) {
        if (controller != clientController) {
          controller.sink.add(request);
        }
      });
    }).onError((e) {
      print(e);

      _controllers.remove(clientController);
      clientController.close();
      print('Disconnected: #${request.hashCode}');
    });

    await for (var message in clientController.stream) {
      print('Received message: ${message.content}');
      yield message;
    }
  }
}
