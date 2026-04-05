import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'package:purchase_erp/Profile/privacy_policy.dart';
import 'package:purchase_erp/Profile/terms_of_service.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// TOP CURVE
          Container(
            height: height * 0.22,
            width: width,
            decoration: const BoxDecoration(
              color: Color(0xff26A69A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(200),
                bottomRight: Radius.circular(200),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.shopping_cart,
                size: width * 0.25,
                color: Colors.white,
              ),
            ),
          ),

          /// MAIN CONTENT
          Positioned.fill(
            top: height * 0.24,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Purchase Management",
                    style: TextStyle(
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff26A69A),
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  /// USERNAME
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Username",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.01),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      hintText: "Enter Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  /// PASSWORD
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Forgot Password?"),
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  /// LOGIN BUTTON
                  SizedBox(
                    width: width,
                    height: height * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff26A69A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: width * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),
                  const Text("or"),

                  SizedBox(height: height * 0.01),
                  const Text("continue with"),

                  SizedBox(height: height * 0.02),

                  /// SOCIAL LOGIN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: width * 0.06,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          "assets/apple.png",
                          width: width * 0.12,
                        ),
                      ),
                      SizedBox(width: width * 0.05),
                      CircleAvatar(
                        radius: width * 0.06,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          "assets/google.png",
                          width: width * 0.07,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.02),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(
                          text: "By continuing you agree to our\n",
                        ),
                        TextSpan(
                          text: "terms of service ",
                          style: const TextStyle(
                            color: Color(0xff26A69A),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TermsOfServiceScreen(),
                                ),
                              );
                            },
                        ),
                        TextSpan(
                          text: "privacy policy ",
                          style: const TextStyle(
                            color: Color(0xff26A69A),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PrivacyPolicyScreen(),
                                ),
                              );
                            },
                        ),
                        const TextSpan(text: "content policy"),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Already have an account? "),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xff26A69A),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// BOTTOM CURVE
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                height: height * 0.12,
                width: width,
                color: const Color(0xff26A69A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height * 0.35);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.0,
      size.width * 0.5,
      size.height * 0.35,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.35,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
