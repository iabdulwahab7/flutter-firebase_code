import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firestore/utils/utils.dart';
import 'package:firebase_firestore/widgets/roundbutton_widget.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  bool loading = false;
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.deepPurple,
                  ),
                  hintText: "Enter email",
                  hintStyle: TextStyle(color: Colors.deepPurple),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter email";
                  }
                  return null;
                }),
          ),
          RoundButtonWidget(
              title: "Login",
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                auth
                    .sendPasswordResetEmail(
                        email: emailController.text.toString())
                    .then((value) {
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                  Utils().toastMessage("Email send");
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              }),
        ],
      ),
    );
  }
}
