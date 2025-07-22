// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:grpc_chat/src/common_widgets/providers/channel.dart';
import 'package:grpc_chat/src/features/chat/domain/chat_message.dart';
import 'package:grpc_chat/src/generated/chat.pbgrpc.dart';
import 'package:rxdart/rxdart.dart';

class ChatRepository {
  ChatRepository({
    required ChatServiceClient client,
    required String sender,
  })  : _client = client,
        _sender = sender {
    // Initialize the repository, if needed.
    _serverResponse = _client.connect(_messageController.stream);
  }
  final String _sender;

  final ChatServiceClient _client;
  late final Stream<Message> _serverResponse;

  final StreamController<Message> _messageController =
      StreamController.broadcast();

  ValueStream<List<ChatMessage>> get watchMessages =>
      _serverResponse.map(ChatMessage.fromProto).scan<List<ChatMessage>>(
        (acc, message, _) => [...acc, message],
        [],
      ).shareValueSeeded([]);

  void sendMessage(ChatMessage message) {
    final messageWithSender = message.copyWith(
      sender: _sender,
    );
    _messageController.add(messageWithSender.toProto());
  }

  void dispose() {
    _messageController.close();
  }
}

final senderProvider = Provider<String>((ref) {
  return 'user123'; // Replace with the actual sender's identifier, e.g., user ID or name.
});

final chatClientProvider = Provider<ChatServiceClient>((ref) {
  final channel = ref.watch(channelProvider);
  return ChatServiceClient(channel);
});

final chatRepositoryProvider = Provider.autoDispose<ChatRepository>((ref) {
  final client = ref.watch(chatClientProvider);
  final sender = ref.watch(senderProvider);
  final repository = ChatRepository(
    client: client,
    sender: sender,
  );
  ref.onDispose(() {
    repository.dispose();
  });
  return repository;
});
