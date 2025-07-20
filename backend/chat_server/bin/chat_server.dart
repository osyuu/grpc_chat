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
  final _controllers = <StreamController<Message>, void>{};

  @override
  Stream<Message> connect(ServiceCall call, Stream<Message> request) async* {
    final clientController = StreamController<Message>();
    _controllers[clientController] = null;

    request.listen((request) {
      print('Connected: ${request.sender} #${request.hashCode}');

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
      message.id = Uuid().v1();
      message.createdAt = Timestamp.fromDateTime(DateTime.now());
      yield message;
    }
  }
}
