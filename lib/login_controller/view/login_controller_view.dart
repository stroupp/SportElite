import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_elite_app/authentication_screen/authentication_type/view/authentication_type_screen.dart';
import 'package:sport_elite_app/dashboard/dashboard_view.dart';

class LoginController extends StatefulWidget {
  const LoginController({Key? key}) : super(key: key);

  @override
  State<LoginController> createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return const DashboardWithDrawer();
    }
    return const AuthenticationTypeScreen();
  }
}
