// import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanisaapp/bloc/addReply.dart';
import 'package:kanisaapp/bloc/pointer.dart';
import 'package:kanisaapp/home/screens/index.dart';
import 'package:kanisaapp/utils/my_colors.dart';
import 'package:provider/provider.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
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
        // child: DevicePreview(builder: (context) => MyApp()),
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
