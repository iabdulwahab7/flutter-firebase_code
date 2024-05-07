import 'package:firebase_firestore/firebase_services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    splashServices.isLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Hello Firebase",
          style: TextStyle(
              fontSize: 32,
              color: Colors.deepPurple,
              letterSpacing: 8,
              fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
