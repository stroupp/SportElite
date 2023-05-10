import 'package:flutter/material.dart';

// Test screen size
const double testScreenWidth = 414;
const double testScreenHeight = 896;

const double widthRatio = (393 / 154);
const double heightRatio = (844 / 60);
const String imagePath = "assets/images/"; // Warning: Do not change!
const String poppinsFont = "Poppins";

//register screen
const Color greenColor = Color(0xff419779);
const Color yellowColor = Color(0xffFFE241);
const Color blackColor = Color(0xff000000);
const Color whiteColor = Color(0xFFFFFFFF);
const Color blueColor = Color(0xFF2675EC);
// Signup Screen

// Messaging Screen
const Color messagingBackgroundBlackColor = Color(0xff000000);
const Color messagingTitleWhiteColor = Color(0xffececec);
const Color messagingDateGreyColor = Color(0xff848484);
const Color messagingMessageTitleWhiteColor = Color(0xffffffff);
const Color messagingEmptyInboxGreyColor = Color(0xffc7c7c7);
const Color messagingRequestBoxGreyColor = Color(0xffb9b9b9);

// Dashboard Screen
const dashboardWhiteColor = Color(0xffffffff);
const dashboardListViewItemWeeksTextBlackColor = Color(0xff000000);
const dashboardAppbarYellow = Color(0xffffe200);
const dashboardAddTraineeBackgroundColor = Color(0xFFFFFFFF);
const dashboardAddTraineeTitleYellowColor = Color(0xffFFE241);
const dashboardAddTraineeInputFieldHintGreyColor = Color(0xff8a8a8a);
const dashboardAddTraineeSendButtonWhiteColor = Color(0xFFFFFFFF);
const dashboardAddTraineeTermsAndConditionsGreyColor = Color(0xff707070);
const dashboardEmptyTraineeListSubtitleGreyColor = Color(0xffb9b9b9);
const dashboardUserListViewItemOnDismiss = Color(0xffCE0000);
const dashboardNextProgramTitleColor = Color(0xfff02626);
const dashboardAddTraineeHighlightGreenColor = Color(0xff04764E);
const dashboardNextProgramLocationPrepositionColor = Color(0xff01091c);
const dashboardNextProgramLocationColor = Color(0xff04764e);
const dashboardNextProgramDateColor = Color(0xff5b6897);
const dashboardNextProgramPersonTextColor = Color(0xff5b6897);
const dashboardUserListViewSubtitleGreyColor = Color(0xff717171);

const dashboardAddTraineeLinkStyle = TextStyle(
  color: dashboardAddTraineeHighlightGreenColor,
  fontWeight: FontWeight.bold,
  fontSize: 14,
);

InputDecoration dashboardInputFieldDecoration(String hintText) {
  return InputDecoration(
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: dashboardAddTraineeInputFieldHintGreyColor,
        width: 2,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(
          15,
        ),
      ),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: dashboardAddTraineeHighlightGreenColor,
        width: 2,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(
          15,
        ),
      ),
    ),
    label: Text(
      hintText,
      style: const TextStyle(
        fontSize: 14,
        color: dashboardAddTraineeInputFieldHintGreyColor,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

const String dashboardFirestoreUsersCollection = "users";
//Regex for mail validation
String regexCode =
    (r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
