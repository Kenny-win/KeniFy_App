// ignore_for_file: prefer_const_constructors

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';

class Scanner extends StatelessWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
              Colors.purple,
              Colors.orange,
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Please Search For\na QR Code", style: TextStyle(
                fontSize: 30,
                height: 1,
                color: Colors.white
              ),textAlign: TextAlign.center,),
              SizedBox(height: 30,),
              Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40)
                ),
                child: MobileScanner(
                  fit: BoxFit.fill,
                  allowDuplicates: false,
                  onDetect: (barcode, args) {
                    if (barcode.rawValue == null) {
                      debugPrint('Failed to scan Barcode');
                    } else {
                      final String code = barcode.rawValue!;
                      debugPrint('Barcode found! ');
                      if (code == "success") {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("Please Scan a Correct QR Code !"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/auth', (route) => false);
                                },
                                child: Text("ok"),
                              ),
                            ],
                          ),
                        );
                      }
                      print(code);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
