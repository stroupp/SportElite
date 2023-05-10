import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/constants.dart';

class EmptyRequestView extends StatefulWidget {
  int? requestMessages;

  EmptyRequestView({Key? key, this.requestMessages}) : super(key: key);

  @override
  State<EmptyRequestView> createState() => EmptyRequestViewState();
}

class EmptyRequestViewState extends State<EmptyRequestView> {
  //TODO: add these to the localization
  final String messaging_emptyRequestBox_text =
      "Message requests are received from other users who are not in your contact list. ";
  final String messaging_goToMessageControls_text =
      "Go to \"Message Controls\" to decide who can message you.";
  final String messaging_noMessageRequests_text = "No message requests";
  final String messaging_noRequestMessages_text =
      "There are no message requests here.";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 8,
        left: 8,
        bottom: 8,
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              messaging_emptyRequestBox_text,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
                fontWeight: FontWeight.w400,
                color: messagingEmptyInboxGreyColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height:
                  MediaQuery.of(context).size.height * 10.0 / testScreenHeight,
            ),
            Text(
              messaging_goToMessageControls_text,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(
                  11,
                ),
                fontWeight: FontWeight.w400,
                color: yellowColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height:
                  MediaQuery.of(context).size.height * 109 / testScreenHeight,
            ),
            Image.asset(
              "${imagePath}messaging_inbox_emptyRequest_entity.png",
              height:
                  MediaQuery.of(context).size.height * 148 / testScreenHeight,
              width: MediaQuery.of(context).size.width * 175 / testScreenWidth,
            ),
            SizedBox(
              height:
                  MediaQuery.of(context).size.height * 19 / testScreenHeight,
            ),
            Text(
              messaging_noMessageRequests_text,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(
                  22,
                ),
                fontWeight: FontWeight.w400,
                color: yellowColor,
                //
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height:
                  MediaQuery.of(context).size.height * 10 / testScreenHeight,
            ),
            Text(
              messaging_noRequestMessages_text,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(
                  15,
                ),
                fontWeight: FontWeight.w400,
                color: messagingEmptyInboxGreyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
