import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shop/main.dart';
import 'package:shop/screens/tet1.dart';

import '../AuthService.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Get.to(Auth());
    });
    return Scaffold(
      backgroundColor: Colors.blue, // Màu nền của màn hình mở app
      body: Center(
        child: Image.asset(
          'assets/images/splash_image1.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        )
      ),
    );
  }
}
