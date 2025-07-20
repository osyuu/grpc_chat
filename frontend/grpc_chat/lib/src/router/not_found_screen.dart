import 'package:flutter/material.dart';
import 'package:grpc_chat/src/common_widgets/empty_placeholder_widget.dart';
import 'package:grpc_chat/src/localization/string_hardcoded.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: EmptyPlaceholderWidget(
        message: '404 - Page not found!'.hardcoded,
      ),
    );
  }
}
