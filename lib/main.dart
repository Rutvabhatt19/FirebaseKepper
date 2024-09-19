import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_kepper/Controller/BookmarkProvider.dart';
import 'package:firebase_kepper/Controller/Themecontroller.dart';
import 'package:firebase_kepper/View/SplashScreen.dart';
import 'package:firebase_kepper/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }catch(e){
    print(e);
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ThemeController(),),
    ChangeNotifierProvider(create: (context) => BookmarkProvider(),),
  ],child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final themecontroller=Provider.of<ThemeController>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themecontroller.isDarkTheme?ThemeData.dark():ThemeData.light(),
      home: SplashScreen(),
    );
  }
}


