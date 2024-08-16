import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase_options.dart';
import 'package:flutter_chat_app/provider/auth_provider.dart';
import 'package:flutter_chat_app/provider/chat_provider.dart';
import 'package:flutter_chat_app/provider/image_picker_provider.dart';
import 'package:flutter_chat_app/provider/theme_provider.dart';
import 'package:flutter_chat_app/screens/splash_screen.dart';

import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    
  );
  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviders()),
        ChangeNotifierProvider(create: (_) => ChatService()),
        ChangeNotifierProvider(create: (_) => ImagePickerProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
          theme: ThemeData(
            brightness:
                themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen());
    });
  }
}
