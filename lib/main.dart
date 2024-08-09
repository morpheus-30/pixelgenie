import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pixelgenie/Providers/StickerPackListProvderClass.dart';
import 'package:pixelgenie/Screens/GettingStartedScreen.dart';
import 'package:pixelgenie/Screens/LoginScreen.dart';
import 'package:pixelgenie/Screens/PreviousStickersScreen.dart';
import 'package:pixelgenie/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // MobileAds.instance.initialize();
  runApp(const MyApp());
}

const stickers = [
  ["assets/images/abc.webp", '😄', '😀'],
  ["assets/images/bcd.webp", '😄', '😀'],
  ["assets/images/efg.webp", '😄', '😀'],
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => StickerPackListProvderClass()),
      ],
      child: MaterialApp(
        routes: {
          '/gettingStarted': (context) => GettingStartedScreen(),
          '/login': (context) => LoginScreen(),
          '/previousStickers': (context) => PreviousStickerScreen(),
        },
        home: GettingStartedScreen(),
      ),
    );
  }
}
