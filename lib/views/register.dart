import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController authController = Get.find<AuthController>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsetsGeometry.only(left: 24, right: 24, top: 56, bottom: 36), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF2F6BFF),
                  borderRadius: BorderRadius.circular(18)
                ),
                child: Image.asset("assets/icons/sun.png", height: 30, width: 30,),
              )
            ,
          SizedBox(height: 28,),
          Text("Create your account", style: GoogleFonts.sora(
            fontWeight: FontWeight.w800,
            fontSize: 28,
            color: Color(0xFF0B1B3A)

          ),),
          Text("Save cities and notes, and sync them on every device.", style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Color(0xFF5A6B8C)

          ),),
          SizedBox(height: 28,),Text("Full name", style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF5A6B8C),
              height: 2
          ),),
          TextField(
            cursorColor: Color(0xFF5A6B8C),
            cursorHeight: 16,
            controller: fullNameController,
            decoration: InputDecoration(
                hoverColor: Colors.transparent,
                fillColor: Colors.white,
                filled: true,

                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: Color(0xFFDCE5F7).withValues(alpha: 0.5)
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: Color(0xFFDCE5F7)
                    )
                ),

                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                hint: Text("Shahzaib Ali", style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF5A6B8C)

                ),)
            ),
          )
          ,SizedBox(
            height: 16,
          ),
          Text("Email", style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF5A6B8C),
            height: 2
          ),),
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
                  color: Color(0xFFDCE5F7).withValues(alpha: 0.5)
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: Color(0xFFDCE5F7)
                  )
              ),

              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              hint: Text("shahzaib@example.com", style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF5A6B8C)

              ),)
            ),
          )
        ,SizedBox(
            height: 16,
          ),
          Text("Password", style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF5A6B8C),
              height: 2
          ),),
          Obx(() => TextField(
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
                    authController.toggleObscurity(
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(authController.isObscured.value ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: Color(0xFFDCE5F7).withValues(alpha: 0.5)
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                        color: Color(0xFFDCE5F7)
                    )
                ),

                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                hint: Text("Enter your password", style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF5A6B8C)

                ),)
            ),
          ),)

          ,SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Color(0xFFFFF3CC),
              borderRadius: BorderRadius.circular(14)
            ),
            child: Text("Demo account: demo@nimbus.app / demo1234", style: GoogleFonts.dmMono(
              color: Color(0xFFB54708),
              fontSize: 14,
              fontWeight: FontWeight(400)
            ),),
          ),SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () => authController.signUp(fullName: fullNameController.text, email: emailController.text, password: passwordController.text),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: Color(0xFF2F6BFF),
                  borderRadius: BorderRadius.circular(14)
              ),
              child: Center(
                child: Obx( () => Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(authController.isLoading.value) ...[
                        CircularProgressIndicator(color: Colors.white, ),
                      ],
                      Text(authController.isLoading.value ? "Creating account" : "Create account", style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight(600)
                      ),),
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
              Text("Already have an account?", style: GoogleFonts.dmSans(
                  color: Color(0xFF5A6B8C),
                  fontSize: 15,
                  fontWeight: FontWeight(400)
              )),InkWell(
                onTap: () {
                  Get.toNamed('/login');
                },
                child: Text("Log in", style: GoogleFonts.dmSans(
                color: Color(0xFF2F6BFF),
                fontSize: 15,
                fontWeight: FontWeight(700)
                          )),
              ),
            ],
          )


        ],
      ),),
    );
  }
}
