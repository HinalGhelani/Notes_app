import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/notes_helper.dart';

class SignInPage extends StatefulWidget {
  // final SharedPreferences prefs;
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isEye = false;

  String? email;
  String? password;

  final GlobalKey<FormState> signInKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // bool isLoggedIn = false;
  // String sfLogin = '';

  // checkLogin() {
  //   isLoggedIn = widget.prefs.getBool(sfLogin) ?? false;
  //   if(isLoggedIn){
  //     Navigator.of(context).pushReplacementNamed('/');
  //     widget.prefs.setBool(sfLogin, false);
  //   }
  // }
  //
  // login(){
  //   widget.prefs.setBool(sfLogin, true);
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   checkLogin();
  // }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff03111C).withOpacity(0.2),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: h,
              width: w,
              color: const Color(0xff03111C).withOpacity(0.2),
              alignment: const Alignment(0, -1.08),
              child: Image.asset(
                "assets/images/Notes_logo.png",
                height: 180,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 530,
                width: w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade600,
                        spreadRadius: 1,
                        blurRadius: 15)
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100),
                  ),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: signInKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Poppins",
                            color: Color(0xff03111C),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xff03111C).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "please enter this...";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                email = emailController.text;
                              });
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xff03111C).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: passwordController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "please enter this...";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                password = passwordController.text;
                              });
                            },
                            textInputAction: TextInputAction.done,
                            obscureText: (isEye == true) ? true : false,
                            decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: (isEye == true)
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isEye = !isEye;
                                        });
                                      },
                                      icon: const Icon(Icons.remove_red_eye),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isEye = !isEye;
                                        });
                                      },
                                      icon: const Icon(
                                          Icons.remove_red_eye_outlined),
                                    ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () async {
                            if (signInKey.currentState!.validate()) {
                              signInKey.currentState!.save();

                              Map<String, dynamic> res =
                                  await FirebaseAuthHelper.firebaseAuthHelper
                                      .signIn(
                                          email: email!, password: password!);

                              if (res['user'] != null) {
                                // login();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Signin In Successful...",
                                      style: TextStyle(
                                        color: Color(0xff03111C),
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.white,
                                  ),
                                );
                                Navigator.of(context).pushReplacementNamed('/',
                                    arguments: res['user']);
                              }
                              else if (res['error'] != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(res['error']),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: const Color(0xff03111C),
                                  ),
                                );
                              }
                              else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Signin in failed..."),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Color(0xff03111C),
                                  ),
                                );
                              }
                            }
                            setState(() {
                              emailController.clear();
                              passwordController.clear();
                              email = null;
                              password = null;
                            });
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xff03111C),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 65),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "By continuing you agree to create note's",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Terms of Use. ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Read our ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Privacy Policy.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
