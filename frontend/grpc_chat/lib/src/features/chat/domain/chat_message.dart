// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:grpc_chat/src/generated/chat.pbgrpc.dart';

typedef MessageID = String;

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.createdAt,
  });

  final MessageID id;
  final String sender;
  final String content;
  final DateTime createdAt;

  ChatMessage copyWith({
    MessageID? id,
    String? sender,
    String? content,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object> toMap() {
    return <String, Object>{
      'id': id,
      'sender': sender,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromMap(Map<String, Object> map) {
    return ChatMessage(
      id: map['id'] as MessageID,
      sender: map['sender'] as String,
      content: map['content'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, Object>);

  Message toProto() => Message(
        sender: sender,
        content: content,
      );
  static ChatMessage fromProto(Message msg) => ChatMessage(
        id: msg.id,
        sender: msg.sender,
        content: msg.content,
        createdAt: msg.createdAt.toDateTime(),
      );

  @override
  String toString() {
    return 'ChatMessage(id: $id, sender: $sender, content: $content, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.sender == sender &&
        other.content == content &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sender.hashCode ^
        content.hashCode ^
        createdAt.hashCode;
  }
}
