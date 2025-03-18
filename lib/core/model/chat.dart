import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_structure/core/model/message.dart';

class Chat {
  final String id;
  final List<String> participants;
  final String? groupName;
  final String? groupImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastMessageSenderId;
  final bool isGroup;
  final MessageType lastMessageType;
  final int unreadCount;

  Chat({
    required this.id,
    required this.participants,
    this.groupName,
    this.groupImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSenderId,
    required this.isGroup,
    required this.lastMessageType,
    required this.unreadCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'groupName': groupName,
      'groupImage': groupImage,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'lastMessageSenderId': lastMessageSenderId,
      'isGroup': isGroup,
      'lastMessageType': lastMessageType.toString(),
      'unreadCount': unreadCount,
    };
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      participants: List<String>.from(json['participants']),
      groupName: json['groupName'],
      groupImage: json['groupImage'],
      lastMessage: json['lastMessage'],
      lastMessageTime: (json['lastMessageTime'] as Timestamp).toDate(),
      lastMessageSenderId: json['lastMessageSenderId'],
      isGroup: json['isGroup'],
      lastMessageType: MessageType.values.firstWhere(
          (e) => e.toString() == json['lastMessageType'],
          orElse: () => MessageType.text),
      unreadCount: json['unreadCount'],
    );
  }
}
