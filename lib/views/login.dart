import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/api.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/controllers/auth_controller.dart';
import 'package:untitled/views/register.dart';

import '../constants/routes.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find<AuthController>();
  final emailController = TextEditingController(text: 'demo@nimbus.app');
  final passwordController = TextEditingController(text: 'demo1234');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.only(
          left: 24,
          right: 24,
          top: 56,
          bottom: 36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF2F6BFF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Image.asset("assets/icons/sun.png", height: 30, width: 30),
            ),
            SizedBox(height: 28),
            Text(
              "Welcome back",
              style: GoogleFonts.sora(
                fontWeight: FontWeight.w800,
                fontSize: 28,
                color: Color(0xFF0B1B3A),
              ),
            ),
            Text(
              "Log in to see weather for the cities you care about.",
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Color(0xFF5A6B8C),
              ),
            ),
            SizedBox(height: 28),
            Obx(
              () => authController.errorMsg.value != null
                  ? Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Color(0xFFFEE4E2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            spacing: 6,
                            children: [
                              Icon(
                                Icons.emergency,
                                size: 16,
                                color: Color(0xFFD92D20),
                              ),
                              Text(
                                authController.errorMsg.value!,
                                style: GoogleFonts.dmSans(
                                  color: Color(0xFFD92D20),
                                  fontSize: 14,
                                  fontWeight: FontWeight(600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    )
                  : SizedBox(),
            ),
            Text(
              "Email",
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF5A6B8C),
                height: 2,
              ),
            ),
            TextField(
              cursorColor: Color(0xFF5A6B8C),
              cursorHeight: 16,
              controller: emailController,

              decoration: InputDecoration(
                hoverColor: Colors.transparent,
                fillColor: Colors.white,
                filled: true,

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Color(0xFFDCE5F7).withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Color(0xFFDCE5F7)),
                ),

                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                hint: Text(
                  "you@example.com",
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF5A6B8C),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Password",
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFF5A6B8C),
                height: 2,
              ),
            ),
            Obx(
              () => TextField(
                cursorColor: Color(0xFF5A6B8C),
                cursorHeight: 16,
                controller: passwordController,
                obscureText: authController.isObscured.value,

                decoration: InputDecoration(
                  hoverColor: Colors.transparent,
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: InkWell(
                    onTap: () {
                      authController.toggleObscurity();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        authController.isObscured.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xFFDCE5F7).withValues(alpha: 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Color(0xFFDCE5F7)),
                  ),

                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hint: Text(
                    "Enter your password",
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xFF5A6B8C),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color(0xFFFFF3CC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "Demo account: demo@nimbus.app / demo1234",
                style: GoogleFonts.dmMono(
                  color: Color(0xFFB54708),
                  fontSize: 14,
                  fontWeight: FontWeight(400),
                ),
              ),
            ),
            SizedBox(height: 24),
            InkWell(
              onTap: () => authController.login(
                email: emailController.text,
                password: passwordController.text,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Color(0xFF2F6BFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        if (authController.isLoading.value) ...[
                          Container(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ],
                        Text(
                          authController.isLoading.value
                              ? "Logging in"
                              : "Log in",
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight(600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                Text(
                  "New to Nimbus?",
                  style: GoogleFonts.dmSans(
                    color: Color(0xFF5A6B8C),
                    fontSize: 15,
                    fontWeight: FontWeight(400),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed('/register');
                  },
                  child: Text(
                    "Create account",
                    style: GoogleFonts.dmSans(
                      color: Color(0xFF2F6BFF),
                      fontSize: 15,
                      fontWeight: FontWeight(700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
