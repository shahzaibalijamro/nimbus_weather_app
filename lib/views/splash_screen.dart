import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/api.dart';
import 'package:untitled/constants/routes.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/views/home_screen.dart';
import 'package:untitled/views/login.dart';

import '../models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;
  String? errorMsg;

  ApiController apiController = ApiController();
  @override
  void initState() {
    print("INIT");
    initCalled();
    // TODO: implement initState
    super.initState();


  }

  void initCalled() async {
    await checkForUser();
  }

  Future<void> checkForUser() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });
    final response = await apiController.get(url: ApiEndpoints.me, isSecured: true);
    int statusCode = response.$1;
    if(statusCode == 201 || statusCode == 200) {
      final apiResponse = response.$2;
      User user = userFromJson(apiResponse);
      Get.offAllNamed(AppRoutes.main, arguments: {
        'user' : user
      });
    } else {
      if(statusCode == 707) {
        errorMsg = "NO INTERNET! PLEASE CHECK YOUR INTERNET CONNECTION";
        isLoading = false;
        return;
      }
      Get.offAllNamed(AppRoutes.login);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B1B3A),
      body: Center(child: Column(
        children: [
          Spacer(),
          Text("Nimbus", style: GoogleFonts.sora(
            fontSize: 44,
            color: Colors.white,
            fontWeight: FontWeight.w800
          ),),
          SizedBox(height: 10,),
          Text("Weather & city guide", style: GoogleFonts.dmSans(
              fontSize: 16,
              color: Color(0xFF9FB4DD),
              fontWeight: FontWeight.w400
          ),),
          SizedBox(height: 24,),
          Text("Checking your session…", style: GoogleFonts.dmMono(
              fontSize: 13,
              color: Color(0xFF9FB4DD),
              fontWeight: FontWeight.w400
          ),),
          SizedBox(height: 24,),
          if(isLoading) ...[
            Container(width: 44,height: 44,child: CircularProgressIndicator(color: Colors.white,))
          ],
          if(errorMsg != null) ... [
            InkWell(
              onTap: checkForUser,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18)
                ),
                child: Text("RETRY", style: GoogleFonts.dmSans(
                    fontSize: 16,
                    color: Color(0xFF9FB4DD),
                    fontWeight: FontWeight.w400
                ), ),
              ),
            )
          ],
          Spacer()
        ],
      ),),
    );
  }
}
