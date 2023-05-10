import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport_elite_app/utils/constants.dart';
import 'package:sport_elite_app/utils/localization_en.dart';
import '../../login_controller/view/login_controller_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginController(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF383838), Color(0xFF000000)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "${imagePath}Layer 4.svg",
                width: MediaQuery.of(context).size.width / (390 / 153.37),
                height: MediaQuery.of(context).size.height / (844 / 143.35),
              ),
              const SizedBox(
                height: 13.69,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / (390 / 180),
                height: MediaQuery.of(context).size.width / (844 / 150),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    scene_watchSplashScreen_splashScreen_title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFFFFFFF),
                      fontSize: ScreenUtil().setSp(
                        40,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
