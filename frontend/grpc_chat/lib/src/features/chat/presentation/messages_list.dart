import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_chat/src/common_widgets/async_value_widget.dart';
import 'package:grpc_chat/src/features/chat/data/chat_repository.dart';

class MessagesList extends ConsumerWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageValue = ref.watch(messagesProvider);
    return AsyncValueWidget(
      value: messageValue,
      data: (message) {
        return ListTile(
          title: Text('${message.sender}: ${message.content}'),
          trailing: Text(message.createdAt.toIso8601String()),
        );
      },
    );
  }
}
