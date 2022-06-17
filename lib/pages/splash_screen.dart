import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double flexWidth() {
    return MediaQuery.of(context).size.width;
  }

  double flexHeight() {
    return MediaQuery.of(context).size.height;
  }

  double flexWidthPercent(width) {
    return (width / 100) * flexWidth();
  }

  double flexHeightPercent(height) {
    return (height / 100) * flexHeight();
  }

  @override
  void initState() {
    super.initState();
    callback() {
      return Navigator.pushNamedAndRemoveUntil(
        context, '/auth', (route) => false);
    }

    Timer(const Duration(seconds: 2), callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/mylogo.png",
                width: flexWidthPercent(38),
                height: flexHeightPercent(38),
              ),
              Shimmer.fromColors(
                child: const Text(
                  "KenniFy",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                baseColor: Colors.white,
                highlightColor: Colors.cyan,
              ),
              Divider(
                color: Colors.white,
                indent: flexWidthPercent(15),
                endIndent: flexWidthPercent(15),
              ),
              const Text(
                "AI Music App",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ]),
      ),
    );
  }
}
