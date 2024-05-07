// ignore_for_file: unused_import

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firestore/view/auth/login_view.dart';
import 'package:firebase_firestore/view/firestore_database/firestore_data_view.dart';
import 'package:flutter/material.dart';

import '../view/firebase_database/firebase_data_view.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DataViewFirebaseDatabase())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginView())));
    }
  }
}
