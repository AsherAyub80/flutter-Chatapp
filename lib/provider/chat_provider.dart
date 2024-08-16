import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Stream<List<ChatMessage>> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatMessage.fromDocument(doc)).toList());
  }

  Future<void> sendMessage(String chatRoomId, String message) async {
    final user = _auth.currentUser;
    try {
      _setLoading(true); 
      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'text': message,
        'senderId': user?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
    } finally {
      _setLoading(false); // Set loading to false after message is sent
    }
  }
  

  Future<Map<String, dynamic>?> getLastMessageDetails(String chatRoomId) async {
    try {
      final snapshot = await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final lastMessageDoc = snapshot.docs.first;
      final lastMessage = ChatMessage.fromDocument(lastMessageDoc);

      return {
        'text': lastMessage.text,
        'timestamp':
            lastMessage.timestamp?.toDate(), // Convert Timestamp to DateTime
        'senderId': lastMessage.senderId, // Add senderId here
      };
    } catch (e) {
      print('Error fetching last message details: $e');
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); 
  }
}

class ChatMessage {
  final String senderId;
  final String text;
  final Timestamp? timestamp;

  ChatMessage({
    required this.senderId,
    required this.text,
    this.timestamp,
  });

  factory ChatMessage.fromDocument(DocumentSnapshot doc) {
    return ChatMessage(
      senderId: doc['senderId'] ?? '',
      text: doc['text'] ?? '',
      timestamp: doc['timestamp'] as Timestamp?,
    );
  }

  DateTime? get formattedTimestamp => timestamp?.toDate();
}
