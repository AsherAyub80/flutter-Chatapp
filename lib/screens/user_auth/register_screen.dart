import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/provider/image_picker_provider.dart';
import 'package:flutter_chat_app/provider/auth_provider.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key, this.onTap}) : super(key: key);
  final Function()? onTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    final authProvider = Provider.of<AuthProviders>(context);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: height * 0.55,
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.03),
                Image.asset(
                  'images/chatlogo.png',
                  height: 80,
                  width: 80,
                ),
                SizedBox(height: 2),
                Text(
                  'ChatNest',
                  style: TextStyle(
                      height: 0.90,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 15,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  'Chat with anyone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.23),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width * 0.05),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 2,
                        blurRadius: 4,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await imageProvider.pickImage(ImageSource.gallery);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.grey.shade200,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: imageProvider.image != null
                                    ? Image.file(
                                        imageProvider.image!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'images/Profile_avatar_placeholder_large.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(Icons.add,
                                      size: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomField(
                              controller: nameController,
                              hint: 'Username',
                              suffix: SizedBox(),
                              prefix: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                            ),
                            CustomField(
                              controller: emailController,
                              hint: 'Email',
                              suffix: SizedBox(),
                              prefix: Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!RegExp(r'\S+@\S+\.\S+')
                                    .hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            CustomField(
                              controller: passwordController,
                              hint: 'Password',
                              obscureText: isVisible,
                              suffix: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: Icon(
                                    isVisible
                                        ? FontAwesomeIcons.eyeSlash
                                        : FontAwesomeIcons.eye,
                                    color: Colors.black,
                                  )),
                              prefix: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 6) {
                                  return 'Password should be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            if (_isLoading)
                              CircularProgressIndicator()
                            else
                              AuthButton(
                                title: 'Register',
                                onTap: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    try {
                                      await authProvider.signUp(
                                        emailController.text,
                                        passwordController.text,
                                        nameController.text,
                                      );

                                      if (imageProvider.image != null) {
                                        await imageProvider.uploadImage();
                                        String? imageUrl =
                                            imageProvider.imageUrl;

                                        await authProvider
                                            .updateProfileImage(imageUrl ?? '');
                                        print(imageUrl);
                                      }
                                    } catch (e) {
                                      print('Registration Error: $e');
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    }
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: widget.onTap,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        minimumSize: Size(320, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class CustomField extends StatelessWidget {
  const CustomField({
    Key? key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    required this.suffix,
    required this.prefix,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final Widget suffix;
  final Widget prefix;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              suffix,
            ],
          ),
          prefixIcon: prefix,
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $hint';
              }
              return null;
            },
      ),
    );
  }
}
