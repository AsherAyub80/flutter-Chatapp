import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/home_screen.dart';
import 'package:flutter_chat_app/screens/user_auth/login_screen.dart';
import 'package:flutter_chat_app/screens/user_auth/register_screen.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //user login
            if (snapshot.hasData) {
              return ContactScreen();
            } else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initialy show login page
  bool showloginpage = true;

  //toggle between login and register page
  void togglePages() {
    setState(() {
      showloginpage = !showloginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showloginpage) {
      return LoginScreen(
        onTap: togglePages,
      );
    } else {
      return RegisterScreen(
        onTap: togglePages,
      );
    }
  }

   String _getChatRoomId(String userAId, String userBId) {
    return userAId.hashCode <= userBId.hashCode
        ? '$userAId\_$userBId'
        : '$userBId\_$userAId';
  }

  Future<void> _createChatRoomIfNotExists(
      String chatRoomId, List<String> participants) async {
    final chatRoomRef =
        FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId);
    final doc = await chatRoomRef.get();

    if (!doc.exists) {
      await chatRoomRef.set({
        'participants': participants,
      });
    }
  }
}
