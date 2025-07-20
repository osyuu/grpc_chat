import 'package:grpc_chat/src/generated/google/protobuf/timestamp.pb.dart';

extension TimestampExtension on Timestamp {
  String toIso8601String() {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(seconds.toInt() * 1000);
    return dateTime.toIso8601String();
  }
}
