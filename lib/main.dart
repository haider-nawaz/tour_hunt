import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:tour_hunt/Views/Company/company_home.dart';
import 'package:tour_hunt/auth/signin_view.dart';

import 'auth/verify_email.dart';
import 'Views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey =
  // "pk_test_51OM8N5Ig1AmjwSTWZztrZZ1ABhpGNBT1cPhz6o3pIFn6kMfQFHDfC4Zs6wgOzjtkJpLcYlM1AHZr6RnQTSZucYfg00FCwqZdKt";

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //FirebaseAuth.instance.signOut();d
    final user = FirebaseAuth.instance.currentUser;
    //final emailVerified = user?.emailVerified ?? false;
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          opacity: .9,
          fit: BoxFit.cover,
          image: AssetImage(
            "assets/background.jpg",
          ),
        ),
      ),
      child: GetMaterialApp(
        title: 'Tour Hunt',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),

        //home: SplashScreen(),
        home: user == null ? const SignInView() : const CompanyHome(),
      ),
    );
  }
}
