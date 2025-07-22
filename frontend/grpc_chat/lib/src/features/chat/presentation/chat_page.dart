import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_chat/src/features/chat/application/chat_service.dart';
import 'package:grpc_chat/src/features/chat/presentation/sliver_messages_list.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: SliverMessagesList(),
            ),
            MessageBar(
              messageBarColor: Colors.transparent,
              onSend: (message) =>
                  ref.read(chatServiceProvider).sendMessage(message),
            )
          ],
        ),
      ),
    );
  }
}
