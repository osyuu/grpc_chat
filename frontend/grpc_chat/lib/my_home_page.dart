import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grpc_chat/src/common_widgets/primary_button.dart';
import 'package:grpc_chat/src/localization/string_hardcoded.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Home Page'),
      ),
      body: Center(
        child: PrimaryButton(
          text: 'Open Chat'.hardcoded,
          onPressed: () => context.goNamed('chat'),
        ),
      ),
    );
  }
}
