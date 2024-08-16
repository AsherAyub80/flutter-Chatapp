import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/onBoardingScreen/on_boarding_screen.dart';
import 'package:flutter_chat_app/screens/user_auth/auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      final storage = GetStorage();
      bool isOnboardingCompleted =
          storage.read<bool>('onboardingCompleted') ?? false;

      if (isOnboardingCompleted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Auth()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 180, 138, 252),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'images/chatlogo.png',
                      height: 120,
                      width: 120,
                    ),
                    Text(
                      'ChatNest',
                      style: TextStyle(
                          height: 0.90,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 25,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Lottie.asset('animation/Animation - 1723731962659.json',
                  height: 200)
            ],
          )
        ],
      ),
    );
  }
}
