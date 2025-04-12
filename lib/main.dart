import 'package:bmcsports/firebase_options.dart';
import 'package:bmcsports/providers/auth_provider.dart';
import 'package:bmcsports/providers/slot_provider.dart';
import 'package:bmcsports/screens/enter_details_screen.dart';
import 'package:bmcsports/screens/home_screen.dart';
import 'package:bmcsports/screens/login_screen.dart';
import 'package:bmcsports/utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<SlotProvider>(
          create: (_) => SlotProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'BMC SPORTS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          useMaterial3: true,
          fontFamily: "Alliance No. 1",
        ),
        home: const LoginScreen(),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const HomeScreen(),
          '/enterDetails': (_) => const EnterDetailsScreen(),
        },
      ),
    );
  }
}
