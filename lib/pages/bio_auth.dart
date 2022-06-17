// ignore_for_file: prefer_const_constructors

import 'package:biometric_local_auth/bio_class/biometric_helper.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BioAuth extends StatefulWidget {
  const BioAuth({Key? key}) : super(key: key);

  @override
  State<BioAuth> createState() => _BioAuthState();
}

class _BioAuthState extends State<BioAuth> {
  bool showBiometrics = false;
  bool isAuthenticated = false;
  String? text = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isBiometricAvailable();
  }

  isBiometricAvailable() async {
    showBiometrics = await BiometricHelper().hasEnrolledBiometrics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // backgroundColor: Colors.black,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: const [
            Colors.purple,
            Colors.orange,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 60),
                  child: Text(
                    "Awesome! Welcome to KeniFy !!",
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 240, 232, 232)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.cyan,
                      child: Text(
                        "Please Authenticate Your Account with Biometric",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 30,
                                offset: Offset(4, 2),
                              )
                            ]),
                        textAlign: TextAlign.center,
                      )),
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: Image.asset(
                        "assets/images/Fingerprint-Authentication.png")),
                //TODO BIOMETRIC FINGER PRINT
                if (showBiometrics)
                  ElevatedButton(
                    onPressed: () async {
                      isAuthenticated = await BiometricHelper().authenticate();
                      setState(() {});
                      if (isAuthenticated) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
                      }
                    },
                    child: const Text(
                      'Finger Print',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
                      },
                      child: Text("Register Another Account")),
                ElevatedButton(
                  onPressed: () {
                    //TODO SCANNER
                    Navigator.pushNamedAndRemoveUntil(context, '/scan', (route) => false);
                  },
                  child: Text("Scan QR Code"),
                ),
              ],
            )
          )),
    ));
  }
}
