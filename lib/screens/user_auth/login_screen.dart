import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, this.onTap}) : super(key: key);
  final Function()? onTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final provider = Provider.of<AuthProviders>(context);

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
                SizedBox(
                  height: 2,
                ),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomField(
                          suffix: Icon(
                            Icons.do_not_touch,
                            color: Colors.transparent,
                          ),
                          prefix: Icon(Icons.person),
                          controller: emailController,
                          hint: 'Email',
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your email' : null,
                        ),
                        CustomField(
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: Icon(isVisible
                                ? FontAwesomeIcons.eyeSlash
                                : FontAwesomeIcons.eye),
                          ),
                          prefix: Icon(Icons.lock),
                          controller: passwordController,
                          hint: 'Password',
                          obscureText: isVisible,
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your password'
                              : null,
                        ),
                        SizedBox(height: 20),
                        AuthButton(
                          title: 'Login',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              provider.signIn(
                                context,
                                emailController.text,
                                passwordController.text,
                              );
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Or',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AuthIcon(
                              icon: Icon(
                                FontAwesomeIcons.google,
                              ),
                            ),
                            SizedBox(width: 10),
                            AuthIcon(
                              icon: Icon(FontAwesomeIcons.facebook),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20), // Space before the bottom section
                Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: widget.onTap,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30), // Extra space at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthIcon extends StatelessWidget {
  const AuthIcon({
    super.key,
    required this.icon,
  });
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: icon,
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
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.validator,
    this.prefix,
    required this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? prefix;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hint,
          prefixIcon: prefix,
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: suffix,
          ),
          hintStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
