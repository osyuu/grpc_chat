// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget(
    this.errorMessage, {
    super.key,
  });

  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      errorMessage,
      style: theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.error,
      ),
    );
  }
}
