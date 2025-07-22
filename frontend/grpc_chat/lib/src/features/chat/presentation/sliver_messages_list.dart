import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_chat/src/common_widgets/async_value_widget.dart';
import 'package:grpc_chat/src/features/chat/application/chat_service.dart';
import 'package:grpc_chat/src/features/chat/data/chat_repository.dart';
import 'package:grpc_chat/src/features/chat/presentation/widgets/message_list_item.dart';

class SliverMessagesList extends ConsumerWidget {
  const SliverMessagesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageValue = ref.watch(messagesProvider);
    final me = ref.watch(senderProvider);
    return AsyncValueWidget(
      value: messageValue,
      data: (message) {
        return CustomScrollView(
          slivers: [
            SliverList.builder(
              itemCount: message.length,
              itemBuilder: (context, index) {
                final chatMessage = message[index];
                return MessageListItem(
                  message: chatMessage.content,
                  sender: chatMessage.sender,
                  timestamp: chatMessage.createdAt,
                  isMe: chatMessage.sender == me,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
