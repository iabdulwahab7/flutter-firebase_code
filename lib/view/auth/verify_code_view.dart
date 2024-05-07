// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firestore/utils/utils.dart';
import 'package:firebase_firestore/view/firebase_database/firebase_data_view.dart';
import 'package:firebase_firestore/widgets/roundbutton_widget.dart';
import 'package:flutter/material.dart';

class VerifyCodeView extends StatefulWidget {
  final String verificationId;
  const VerifyCodeView({super.key, required this.verificationId});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  bool loading = false;
  final codeController = TextEditingController();
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
                controller: codeController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    hintText: "Enter code here",
                    helperText: "Enter the code you recieved on your phone!"),
              ),
            ),
            const SizedBox(height: 24),
            RoundButtonWidget(
                title: "Verify code",
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: codeController.text.toString());

                  try {
                    await auth.signInWithCredential(credential);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DataViewFirebaseDatabase()));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
