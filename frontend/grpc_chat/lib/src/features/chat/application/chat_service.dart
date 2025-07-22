import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_chat/src/features/chat/data/chat_repository.dart';
import 'package:grpc_chat/src/features/chat/domain/chat_message.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  ChatService(this.ref);
  final Ref ref;

  /// Sends a message to the chat repository.
  void sendMessage(String message) {
    final chatMessage = ChatMessage(
      id: Uuid().v1(),
      content: message,
      sender: ref.read(senderProvider),
    );
    ref.read(chatRepositoryProvider).sendMessage(chatMessage);
  }
}

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService(ref);
});

final messagesProvider = StreamProvider.autoDispose<List<ChatMessage>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchMessages;
});
