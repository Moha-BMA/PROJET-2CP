
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chainage1/screens/jinglescreen.dart';

import 'app_state.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Enable immersive mode (auto-hide bars after swipe)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);


  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: JingleScreen(), // Initial screen of your app
    );
  }
}
