import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_chat/src/common_widgets/async_value_widget.dart';
import 'package:grpc_chat/src/features/chat/data/chat_repository.dart';
import 'package:grpc_chat/src/features/chat/presentation/widgets/message_list_item.dart';

class MessagesList extends ConsumerWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageValue = ref.watch(messagesProvider);
    return AsyncValueWidget(
      value: messageValue,
      data: (message) {
        return ListView.builder(
          itemCount: message.length,
          itemBuilder: (context, index) {
            final chatMessage = message[index];
            return MessageListItem(
              message: chatMessage.content,
              sender: chatMessage.sender,
              timestamp: chatMessage.createdAt,
            );
          },
        );
      },
    );
  }
}
