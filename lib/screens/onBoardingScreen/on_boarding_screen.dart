import 'package:flutter/material.dart';
import 'package:flutter_chat_app/onboard/onboarding_list.dart';
import 'package:flutter_chat_app/screens/user_auth/auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page?.toInt() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onBoarding.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        onBoarding[index]['animation'],
                        height: onBoarding[index]['isLarge'] ? 200 : 50,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 20),
                      Text(
                        onBoarding[index]['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        onBoarding[index]['subtitle'],
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.grey.shade400),
                        textAlign: TextAlign.center, // Center align text
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_currentPageIndex == onBoarding.length - 1) {
                final storage = GetStorage();
                storage.write('onboardingCompleted', true);
                print('Onboarding completed flag set');
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Auth()));
              } else {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              height: MediaQuery.of(context).size.height * 0.10,
              width: MediaQuery.of(context).size.width * 0.50,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 180, 138, 252),
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  _currentPageIndex == onBoarding.length - 1
                      ? 'Get Started'
                      : 'Next',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
