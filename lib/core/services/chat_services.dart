import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_structure/core/model/chat.dart';
import 'package:code_structure/core/model/message.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uuid = const Uuid();

  // Create a new chat or get existing one
  Future<String> createOrGetChat(List<String> participants,
      {bool isGroup = false, String? groupName, String? groupImage}) async {
    try {
      if (!isGroup) {
        // For personal chat, check if chat already exists
        final QuerySnapshot existingChats = await _firestore
            .collection('chats')
            .where('participants', arrayContainsAny: participants)
            .where('isGroup', isEqualTo: false)
            .get();

        for (var doc in existingChats.docs) {
          final chat = Chat.fromJson(doc.data() as Map<String, dynamic>);
          if (chat.participants.length == 2 &&
              chat.participants.contains(participants[0]) &&
              chat.participants.contains(participants[1])) {
            return doc.id;
          }
        }
      }

      // Create new chat
      final String chatId = uuid.v4();
      final Chat chat = Chat(
        id: chatId,
        participants: participants,
        groupName: groupName,
        groupImage: groupImage,
        lastMessage: '',
        lastMessageTime: DateTime.now(),
        lastMessageSenderId: participants[0],
        isGroup: isGroup,
        lastMessageType: MessageType.text,
        unreadCount: 0,
      );

      await _firestore.collection('chats').doc(chatId).set(chat.toJson());
      return chatId;
    } catch (e) {
      print('Error creating/getting chat: $e');
      throw Exception('Failed to create/get chat');
    }
  }

  // Send a message
  Future<void> sendMessage(Message message, String chatId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(message.id)
          .set(message.toJson());

      // Update last message in chat
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message.content,
        'lastMessageTime': message.timestamp,
        'lastMessageSenderId': message.senderId,
      });
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message');
    }
  }

  // Get chat messages stream
  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Message.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Get user chats stream
  Stream<List<Chat>> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Chat.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Delete message
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      print('Error deleting message: $e');
      throw Exception('Failed to delete message');
    }
  }
}
