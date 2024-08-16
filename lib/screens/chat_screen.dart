import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/provider/theme_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/provider/chat_provider.dart';
import 'package:flutter_chat_app/provider/auth_provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String receiverName;
  final String? receiverProfileImageUrl;

  ChatScreen(
      {required this.chatRoomId,
      required this.receiverName,
      required this.receiverProfileImageUrl});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthProviders>(context, listen: false);
    final currentUser = authService.user;
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (currentUser == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 5),
                    Text(
                      "Chat",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey.shade600, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CachedNetworkImage(
                              imageUrl: widget.receiverProfileImageUrl ??
                                  'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
                              placeholder: (context, url) => const CircleAvatar(
                                backgroundColor: Colors.purple,
                                child: CircularProgressIndicator(),
                                radius: 30, // Adjust radius as needed
                              ),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 30, // Adjust radius as needed
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                backgroundImage: AssetImage(
                                    'images/Profile_avatar_placeholder_large.png'),
                                radius: 30,
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.receiverName[0].toUpperCase() +
                                      widget.receiverName.substring(1),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Online',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: themeProvider.isDarkMode
                                  ? Colors.purple.withOpacity(0.25)
                                  : Colors.purple.withOpacity(0.50),
                              child: Icon(
                                Icons.phone,
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(
                      thickness: 2,
                      color: Colors.grey.shade400,
                    ),
                    Expanded(
                      child: StreamBuilder<List<ChatMessage>>(
                        stream: chatService.getMessages(widget.chatRoomId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.data!.isEmpty) {
                            return Center(child: Text('Start conversation'));
                          }

                          final messages = snapshot.data!;

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollToBottom();
                          });

                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final isSentByMe =
                                  message.senderId == currentUser.uid;
                              final formattedDate =
                                  message.formattedTimestamp != null
                                      ? DateFormat('h:mm a')
                                          .format(message.formattedTimestamp!)
                                      : 'sending..';
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 1),
                                child: Row(
                                  mainAxisAlignment: isSentByMe
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: isSentByMe
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: isSentByMe
                                                    ? LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          Colors.deepPurple,
                                                          Colors.purple.withOpacity(
                                                              themeProvider
                                                                      .isDarkMode
                                                                  ? 0.4
                                                                  : 0.5)
                                                        ],
                                                      )
                                                    : LinearGradient(
                                                        colors: [
                                                          Colors.grey.shade300,
                                                          Colors.grey.shade300,
                                                        ],
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        message.text,
                                                        style: TextStyle(
                                                          color: isSentByMe
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    isSentByMe
                                                        ? 'You'
                                                        : widget.receiverName,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: isSentByMe
                                                            ? Colors.white70
                                                            : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(height: 5),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              suffixIcon: Transform.rotate(
                                angle: 180 * pi / 90,
                                child: Consumer<ChatService>(
                                    builder: (context, chatService, child) {
                                  return IconButton(
                                    icon: FaIcon(
                                      FontAwesomeIcons.paperPlane,
                                      color: chatService.isLoading
                                          ? Colors.purple.withOpacity(0.2)
                                          : Colors.purple,
                                    ),
                                    onPressed: () async {
                                      if (_messageController.text
                                          .trim()
                                          .isEmpty) {
                                        return;
                                      } else {
                                        if (_messageController.text
                                            .trim()
                                            .isEmpty) return;

                                        await chatService.sendMessage(
                                          widget.chatRoomId,
                                          _messageController.text,
                                        );
                                        _messageController.clear();

                                        _scrollToBottom();
                                        FocusScope.of(context).unfocus();
                                      }
                                    },
                                  );
                                }),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              labelText: 'Message',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
