import 'package:bmcsports/firebase_options.dart';
import 'package:bmcsports/providers/booking_provider.dart';
import 'package:bmcsports/providers/local_db_provider.dart';
import 'package:bmcsports/providers/razorpay_payment_provider.dart';
import 'package:bmcsports/providers/slot_provider.dart';
import 'package:bmcsports/screens/enter_user_details_screen.dart';
import 'package:bmcsports/screens/home_screen.dart';
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
        ChangeNotifierProvider<SlotProvider>(
          create: (_) => SlotProvider(),
        ),
        ChangeNotifierProvider<LocalDbProvider>(
          create: (_) => LocalDbProvider(),
        ),
        ChangeNotifierProvider<RazorpayPaymentProvider>(
          create: (_) => RazorpayPaymentProvider(),
        ),
        ChangeNotifierProvider<BookingProvider>(
          create: (_) => BookingProvider(),
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
        initialRoute: '/enterUserDetails',
        routes: {
          '/home': (_) => const HomeScreen(),
          '/enterUserDetails': (_) => const EnterUserDetailsScreen(),
        },
      ),
    );
  }
}
