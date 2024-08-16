import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';
import 'package:flutter_chat_app/widget/custom_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/provider/auth_provider.dart';
import 'package:flutter_chat_app/provider/chat_provider.dart';
import 'package:shimmer/shimmer.dart';

class ContactScreen extends StatefulWidget {
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  bool isLoading = true;
  List<DocumentSnapshot> users = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    await Future.delayed(Duration(seconds: 2));

    final authService = Provider.of<AuthProviders>(context, listen: false);
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      users = snapshot.docs
          .where((doc) => doc.id != authService.user?.uid)
          .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProviders>(context);
    final currentUser = authService.user;
    final chatService = Provider.of<ChatService>(context);

    if (isLoading || currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Image.asset(
                'images/chatlogo.png',
                height: 60,
                width: 60,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'ChatNest',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 15,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                authService.signOut(context);
              },
              icon: Icon(
                Icons.exit_to_app,
              ),
            ),
          ],
        ),
        body: buildShimmer(10),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Image.asset(
              'images/chatlogo.png',
              height: 60,
              width: 60,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              'ChatNest',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 15,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          CustomSwitch(),
          IconButton(
            onPressed: () {
              authService.signOut(context);
            },
            icon: Icon(
              Icons.exit_to_app_outlined,
              size: 30,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final receiverName = user['username'];
          final chatRoomId = _getChatRoomId(currentUser.uid, user.id);
          final receiveImage = user['profileImageUrl'] ??
              'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541';

          return FutureBuilder<Map<String, dynamic>?>(
            future: chatService.getLastMessageDetails(chatRoomId),
            builder: (context, lastMessageSnapshot) {
              String lastMessageText = '';
              String lastMessageTime = '';
              String senderName = '';

              if (lastMessageSnapshot.hasData) {
                final lastMessageDetails = lastMessageSnapshot.data!;
                lastMessageText = lastMessageDetails['text'] ?? '';
                final timestamp = lastMessageDetails['timestamp'] as DateTime?;
                if (timestamp != null) {
                  lastMessageTime = DateFormat('h:mm a').format(timestamp);
                }
                final senderId = lastMessageDetails['senderId'];
                senderName = senderId != currentUser.uid ? receiverName : 'You';
              }

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        chatRoomId: chatRoomId,
                        receiverName: receiverName,
                        receiverProfileImageUrl: receiveImage,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: receiveImage,
                          placeholder: (context, url) => const CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: CircularProgressIndicator(),
                            radius: 40,
                          ),
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 40,
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            backgroundImage: AssetImage(
                              'images/Profile_avatar_placeholder_large.png',
                            ),
                            radius: 35,
                          ),
                        ),
                        title: Text(
                          receiverName[0].toUpperCase() +
                              receiverName.substring(1),
                        ),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                '${senderName} ${lastMessageText.isEmpty ? '' : ':'} '),
                            Text(
                              lastMessageText.isEmpty
                                  ? ''
                                  : lastMessageText.length > 15
                                      ? '${lastMessageText.substring(0, 15)}...'
                                      : lastMessageText,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        trailing: Text(lastMessageTime),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildShimmer(int itemCount) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                ),
                title: Container(
                  color: Colors.grey[300],
                  width: 150,
                  height: 15,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Container(
                      color: Colors.grey[300],
                      width: 120,
                      height: 15,
                    ),
                    SizedBox(height: 5),
                    Container(
                      color: Colors.grey[300],
                      width: 100,
                      height: 15,
                    ),
                  ],
                ),
                trailing: Container(
                  color: Colors.grey[300],
                  width: 60,
                  height: 15,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getChatRoomId(String userAId, String userBId) {
    return userAId.hashCode <= userBId.hashCode
        ? '$userAId\_$userBId'
        : '$userBId\_$userAId';
  }
}
