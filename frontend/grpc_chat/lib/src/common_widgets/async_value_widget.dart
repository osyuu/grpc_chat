// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_chat/src/common_widgets/error_message_widgwet.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    required this.value,
    required this.data,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, st) => Center(child: ErrorMessageWidget(e.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
