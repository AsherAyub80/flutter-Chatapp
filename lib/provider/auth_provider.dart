// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProviders with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthProviders() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    notifyListeners();
  }

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _showSnackbar(context, 'Sign-in successful');
    } on FirebaseAuthException catch (e) {
      _showSnackbar(context, 'Sign-in failed: ${e.message}');
    } catch (e) {
      // _showSnackbar(context, 'An unexpected error occurred during sign in.');
    }
  }

  Future<void> signUp(String email, String password, String username,
      [String? profileImageUrl]) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('User UID: ${userCredential.user!.uid}');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username,
        'email': email,
        'profileImageUrl': profileImageUrl ?? '',
      });
    } on FirebaseAuthException catch (e) {
    } catch (e) {
      print('Sign-up Error: $e');
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } catch (e) {}
  }

  Future<void> updateProfileImage(String imageUrl) async {
    if (_user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .update({
          'profileImageUrl': imageUrl,
        });
        print(imageUrl);
      } catch (e) {
        print(e);
      }
    } else {}
  }

  Future<Map<String, dynamic>?> getUserData(BuildContext context) async {
    if (_user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();
        return doc.data() as Map<String, dynamic>?;
      } catch (e) {}
    } else {}
    return null;
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
