import 'package:flutter/material.dart';
import 'package:sport_elite_app/authentication_screen/email_signin/view/email_signin_screen.dart';
import 'package:sport_elite_app/dashboard/dashboard_view.dart';
import 'package:sport_elite_app/profile_screen/view/profile_editing.dart';
import 'package:sport_elite_app/profile_screen/view/profile_screen_view.dart';
import '../authentication_screen/authentication_type/view/authentication_type_screen.dart';
import '../authentication_screen/email_signup/view/email_signup_screen.dart';
import '../choose_avatar_screen/view/choose_avatar_page.dart';
import '../user_type_selection_screen/view/user_type_selection_screen.dart';

Future navigateToLoginTypePage(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AuthenticationTypeScreen(),
    ),
  );
}

Future navigateToUserTypeSelectionScreen(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const UserTypeSelectionScreen(),
    ),
  );
}

Future navigateToLoginWithMailScreen(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginWithMailScreen(),
    ),
  );
}

Future navigateToCreateAccount(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const SignUpScreen(),
    ),
  );
}

Future navigateToAvatarPage(BuildContext context, bool comingFromProfilePage) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          ChooseAvatarPage(comingFromProfilePage: comingFromProfilePage),
    ),
  );
}

Future navigateToProfileEdit(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ProfileEdit(),
    ),
  );
}

Future navigateToDashboard(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const DashboardWithDrawer(),

    ),
  );
}

Future navigateToProfilePage(
    BuildContext context, String uid, String email, bool isVisitor) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          ProfilePage(uid: uid, username: email, isVisitor: isVisitor),
    ),
  );
}
