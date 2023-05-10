import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport_elite_app/utils/constants.dart';
import '../../../utils/localization_en.dart';
import '../../../widgets/sport_app_rounded_button.dart';
import '../presenter/reset_password_presenter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ResetPasswordPresenter resetPasswordPresenter = ResetPasswordPresenter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 17.22,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.5, horizontal: 40),
                child: Text(
                  scene_watchResetPasswordScreen_resetPasswordScreen_title,
                  style: TextStyle(
                      color: const Color(0xFFFFE241),
                      fontSize: ScreenUtil().setSp(
                        24,
                      ),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.5, horizontal: 40),
                child: Text(
                  scene_watchResetPasswordScreen_resetPasswordScreen_subTtile,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(
                      14,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: TextFormField(
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(
                    16,
                  ),
                ),
                controller: resetPasswordPresenter.email,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff04764e)),
                  ),
                  labelText: scene_inputEmail_resetPasswordScreen_textField,
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenUtil().setSp(
                      16,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: SportAppRoundedButton(
                inputText: scene_resetPassword_resetPassordScreen_button,
                heightRatio: (844 / 60),
                buttonColor: yellowColor,
                widthRatio: (390 / 318),
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(
                      16,
                    ),
                    fontWeight: FontWeight.bold),
                borderColor: yellowColor,
                customOnPressed: () =>
                    resetPasswordPresenter.resetPasswordPresenter(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
