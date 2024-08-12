import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/screens/action_screen.dart';

import 'package:firebase_crud/screens/login_screen.dart';
import 'package:firebase_crud/screens/posts_screen.dart';
import 'package:firebase_crud/utils/colors.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: KColors.secondaryColor,
          brightness: Brightness.dark,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => LoginScreen(),
          "/posts": (context) => const PostsScreen(),
          "/action": (context) => ActionScreen(),
        },
      ),
    );
  }
}
