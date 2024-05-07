import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firestore/utils/utils.dart';
import 'package:firebase_firestore/view/auth/verify_code_view.dart';
import 'package:firebase_firestore/widgets/roundbutton_widget.dart';
import 'package:flutter/material.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  bool loading = false;
  final phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade100,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade200,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: phoneController,
                maxLength: 13,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    hintText: "+923333333333",
                    helperText: "Enter your phone number with country code"),
              ),
            ),
            const SizedBox(height: 24),
            RoundButtonWidget(
                title: "Send Code",
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  await auth.verifyPhoneNumber(
                    phoneNumber: phoneController.text.toString(),
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(e.toString());
                    },
                    codeSent: (String verificationId, int? token) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyCodeView(
                                  verificationId: verificationId)));
                    },
                    codeAutoRetrievalTimeout: (e) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(e.toString());
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
