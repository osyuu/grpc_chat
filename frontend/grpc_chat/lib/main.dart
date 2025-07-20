import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc_chat/src/app.dart';

void main() async {
  await dotenv.load();
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}
