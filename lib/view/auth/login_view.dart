// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_firestore/utils/utils.dart';
import 'package:firebase_firestore/view/firebase_database/firebase_data_view.dart';
import 'package:firebase_firestore/view/firestore_database/firestore_data_view.dart';
import 'package:firebase_firestore/view/forgot_password_view.dart';
import 'package:firebase_firestore/widgets/roundbutton_widget.dart';
import 'package:flutter/material.dart';

import 'login_with_phone.dart';
import 'signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade100,
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                const Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 16),
                ),
                const SizedBox(height: 100),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Form(
                    key: _formkey,
                    child: Column(children: [
                      TextFormField(
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
                      const SizedBox(height: 16),
                      TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_open_outlined,
                              color: Colors.deepPurple,
                            ),
                            hintText: "Enter Password",
                            hintStyle: TextStyle(color: Colors.deepPurple),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            }
                            return null;
                          }),
                    ]),
                  ),
                ),
                RoundButtonWidget(
                    title: "Login",
                    loading: loading,
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        login();
                      }
                    }),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 180),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordView()));
                      },
                      child: const Text("Forgot Password")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account!"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpView()));
                        },
                        child: const Text(
                          "SigUp ",
                          style: TextStyle(fontSize: 16),
                        ))
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all()),
                  child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginWithPhone()));
                      },
                      child:
                          const Text("Click here to login with phone number")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //methods

  void login() async {
    setState(() {
      loading = true;
    });
    await _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage("Login Successful");
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => const DataViewFirestoreDatabase()));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DataViewFirebaseDatabase()));
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString());
    });
  }
}
