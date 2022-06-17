import 'package:biometric_local_auth/pages/bio_auth.dart';
import 'package:biometric_local_auth/pages/home_page.dart';
import 'package:biometric_local_auth/pages/scanner.dart';
import 'package:biometric_local_auth/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.poppins().fontFamily
      ),
      routes: {
        '/':(context) => const SplashScreen(),
        '/auth': (context)=> const BioAuth(),
        '/scan': (context)=> const Scanner(),
        '/home': (context)=> const HomePage(),
      },
    );
  }
}
