import 'package:flutter/material.dart';

import '../helper/notes_helper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isEye = false;

  String? name;
  String? email;
  String? password;

  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                height: 150,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 570,
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
                    key: signUpFormKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Poppins",
                            color: Color(0xff03111C),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.only(left: 15),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xff03111C).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFormField(
                            controller: nameController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "please enter name...";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                name = nameController.text;
                              });
                            },
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: "Name",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                return "please enter email....";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                email = emailController.text;
                              });
                            },
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                return "please enter password...";
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
                            if (signUpFormKey.currentState!.validate()) {
                              signUpFormKey.currentState!.save();

                              Map<String, dynamic> res =
                                  await FirebaseAuthHelper.firebaseAuthHelper
                                      .signUp(
                                          email: email!, password: password!);

                              if (res['user'] != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Sign Up Successful...",
                                      style: TextStyle(
                                        color: Color(0xff03111C),
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.white,
                                  ),
                                );
                                Navigator.of(context).pushReplacementNamed('/');
                              } else if (res['user'] != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(res['error']),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: const Color(0xff03111C),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Sign up Failed..."),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Color(0xff03111C),
                                  ),
                                );
                                Navigator.of(context).pop();
                              }
                            }
                            setState(() {
                              emailController.clear();
                              passwordController.clear();
                              nameController.clear();
                              email = null;
                              password = null;
                              name = null;
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
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
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
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have any account? ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff03111C),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('logInPage');
                                  },
                                  child: const Text(
                                    "Sign in",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff03111C),
                                    ),
                                  ),
                                ),
                              ],
                            )
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
