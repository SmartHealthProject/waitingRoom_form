import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_demo/firebase_options.dart';
//import 'package:form_demo/forms_screen.dart';
import 'package:form_demo/auth/main_page.dart';
//import 'login_page.dart';

void main() async{
  //async lets us continuously access from our project to our firebase backend
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: MainPage(),
      //home: FormsScreen(),
    );
  }
}