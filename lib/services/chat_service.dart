import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_ease/utils/firebase_handler.dart';

// SOLID Principle: Single Responsibility - This service handles only chat-related operations
class ChatService {
  final FirebaseHandler _firebaseHandler;

  ChatService({FirebaseHandler? firebaseHandler})
      : _firebaseHandler = firebaseHandler ?? FirebaseHandler();

  Future<void> sendMessage(
      String chatId, String message, String senderId, String receiverId) async {
    try {
      final messageDoc = _firebaseHandler.firestore
          .collection('universalMessages')
          .doc(chatId)
          .collection('messages')
          .doc();

      await messageDoc.set({
        'message': message,
        'type': 'text',
        'timestamp': FieldValue.serverTimestamp(),
        'sender': senderId,
        'receiver': receiverId,
      });

      // Update chat room with last message
      final chatDocRef =
          _firebaseHandler.firestore.collection('universalChats').doc(chatId);

      await chatDocRef.set({
        'participants': [senderId, receiverId],
        'lastMessage': message,
        'lastMessageType': 'text',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      // Delete all messages in chat
      final messagesRef = _firebaseHandler.firestore
          .collection('universalMessages')
          .doc(chatId)
          .collection('messages');

      final messagesSnapshot = await messagesRef.get();
      for (var messageDoc in messagesSnapshot.docs) {
        await messageDoc.reference.delete();
      }

      // Delete chat room
      await _firebaseHandler.firestore
          .collection('universalChats')
          .doc(chatId)
          .delete();
    } catch (e) {
      print('Error deleting chat: $e');
      throw Exception('Failed to delete chat: $e');
    }
  }

  Stream<QuerySnapshot<Object?>> getChatMessagesStream(String chatId) {
    try {
      return _firebaseHandler.firestore
          .collection('universalMessages')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (e) {
      print('Error getting chat messages stream: $e');
      return Stream.empty();
    }
  }

  Stream<QuerySnapshot<Object?>> getUserChatsStream(String userId) {
    try {
      return _firebaseHandler.firestore
          .collection('universalChats')
          .where('participants', arrayContains: userId)
          .snapshots();
    } catch (e) {
      print('Error getting user chats stream: $e');
      return Stream.empty();
    }
  }

  String generateChatRoomId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? '${userId1}_${userId2}'
        : '${userId2}_${userId1}';
  }
}

// SOLID Principle: Dependency Inversion - Abstract interface for chat operations
abstract class IChatService {
  Future<void> sendMessage(
      String chatId, String message, String senderId, String receiverId);
  Future<void> deleteChat(String chatId);
  Stream<QuerySnapshot<Object?>> getChatMessagesStream(String chatId);
  Stream<QuerySnapshot<Object?>> getUserChatsStream(String userId);
  String generateChatRoomId(String userId1, String userId2);
}
