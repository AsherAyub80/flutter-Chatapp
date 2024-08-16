import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImagePickerProvider with ChangeNotifier {
  File? _image;
  String? _imageUrl;

  File? get image => _image;
  String? get imageUrl => _imageUrl;

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      print('Image Picking Error: $e');
    }
  }

  Future<void> uploadImage() async {
    if (_image == null) return;

    try {
      final fileName = _image!.path.split('/').last;
      final storageRef = _storage.ref().child('profile_images/$fileName');

      final uploadTask = storageRef.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() {});
      _imageUrl = await snapshot.ref.getDownloadURL();

      notifyListeners();
    } catch (e) {
      print('Upload Error: $e');
    }
  }
}
