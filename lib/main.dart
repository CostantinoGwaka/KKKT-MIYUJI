// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miyuji/bloc/addReply.dart';
import 'package:miyuji/bloc/pointer.dart';
import 'package:miyuji/home/screens/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase properly
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  // Set system UI preferences
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AddReplyData>(
          create: (_) => AddReplyData(),
          lazy: false,
        ),
        ChangeNotifierProvider<AddPointerData>(
          create: (_) => AddPointerData(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: MyColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
