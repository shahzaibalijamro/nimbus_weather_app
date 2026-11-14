import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/icons.dart';
import 'package:untitled/controllers/auth_controller.dart';

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsGeometry.only(
          left: 24,
          right: 24,
          top: 56,
          bottom: 36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2F6BFF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Image.asset(AppIcons.sunWhite, height: 30, width: 30),
            ),
            const SizedBox(height: 28),
            Text(
              'Welcome back',
              style: GoogleFonts.sora(
                fontWeight: FontWeight.w800,
                fontSize: 28,
                color: const Color(0xFF0B1B3A),
              ),
            ),
            Text(
              'Log in to see weather for the cities you care about.',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: const Color(0xFF5A6B8C),
              ),
            ),
            const SizedBox(height: 28),
            Obx(
              () => authController.errorMsg.value != null
                  ? Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE4E2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            spacing: 6,
                            children: [
                              const Icon(
                                Icons.emergency,
                                size: 16,
                                color: Color(0xFFD92D20),
                              ),
                              Text(
                                authController.errorMsg.value!,
                                style: GoogleFonts.dmSans(
                                  color: const Color(0xFFD92D20),
                                  fontSize: 14,
                                  fontWeight: const FontWeight(600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    )
                  : const SizedBox(),
            ),
            Text(
              'Email',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: const Color(0xFF5A6B8C),
                height: 2,
              ),
            ),
            TextField(
              cursorColor: const Color(0xFF5A6B8C),
              cursorHeight: 16,
              controller: emailController,

              decoration: InputDecoration(
                hoverColor: Colors.transparent,
                fillColor: Colors.white,
                filled: true,

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: const Color(0xFFDCE5F7).withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFDCE5F7)),
                ),

                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                hint: Text(
                  'you@example.com',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: const Color(0xFF5A6B8C),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Password',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: const Color(0xFF5A6B8C),
                height: 2,
              ),
            ),
            Obx(
              () => TextField(
                cursorColor: const Color(0xFF5A6B8C),
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
                      color: const Color(0xFFDCE5F7).withValues(alpha: 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFDCE5F7)),
                  ),

                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  hint: Text(
                    'Enter your password',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: const Color(0xFF5A6B8C),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Demo account: demo@nimbus.app / demo1234',
                style: GoogleFonts.dmMono(
                  color: const Color(0xFFB54708),
                  fontSize: 14,
                  fontWeight: const FontWeight(400),
                ),
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () => authController.login(
                email: emailController.text,
                password: passwordController.text,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F6BFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        if (authController.isLoading.value) ...[
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ],
                        Text(
                          authController.isLoading.value
                              ? 'Logging in'
                              : 'Log in',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: const FontWeight(600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                Text(
                  'New to Nimbus?',
                  style: GoogleFonts.dmSans(
                    color: const Color(0xFF5A6B8C),
                    fontSize: 15,
                    fontWeight: const FontWeight(400),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed('/register');
                  },
                  child: Text(
                    'Create account',
                    style: GoogleFonts.dmSans(
                      color: const Color(0xFF2F6BFF),
                      fontSize: 15,
                      fontWeight: const FontWeight(700),
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
