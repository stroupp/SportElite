import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sport_elite_app/dashboard/dashboard_presenter.dart';
import 'package:sport_elite_app/dashboard/entity/offer.dart';
import 'package:sport_elite_app/router/router.dart';
import '../../utils/constants.dart';
import '../../utils/localization_en.dart';

const MAX_DATE_YEAR_SPAN = 2100;

class DashboardAddTraineeView extends StatefulWidget {
  const DashboardAddTraineeView({Key? key}) : super(key: key);

  @override
  State<DashboardAddTraineeView> createState() =>
      _DashboardAddTraineeViewState();
}

class _DashboardAddTraineeViewState extends State<DashboardAddTraineeView> {
  // Members
  final DashboardPresenter _dashboardPresenter = DashboardPresenter();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _traineeProgramController = TextEditingController();
  final _traineeEmailController = TextEditingController();
  final _traineeFormKey = GlobalKey<FormState>();

  DateTime _dateTime = DateTime.now();

  final _dateTimeController = TextEditingController();

  // Getters
  DashboardPresenter get dashboardPresenter => _dashboardPresenter;

  // Free memory when the widget is disposed
  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneNumberController.dispose();
    _traineeProgramController.dispose();
    _traineeEmailController.dispose();
    super.dispose();
  }

  // Called when the widget is initialized
  @override
  void initState() {
    _dateTimeController.text = DateFormat('yyyy-MM-dd – kk:mm')
        .format(_dateTime); //set the initial value of text field
    super.initState();
  }

  Future<DateTime?> pickDate() async {
    return showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(MAX_DATE_YEAR_SPAN),
    );
  }

  Future<TimeOfDay?> pickTime() async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    // User pressed on 'Cancel'
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    // User pressed on 'Cancel'
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(
      () {
        _dateTime = dateTime;
        _dateTimeController.text =
            DateFormat('yyyy-MM-dd – kk:mm').format(_dateTime);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashboardAddTraineeBackgroundColor,
      appBar: AppBar(
        backgroundColor: dashboardAddTraineeBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            navigateToDashboard(context);
          },
          icon: SvgPicture.asset(
            '${imagePath}back_button.svg',
            width: MediaQuery.of(context).size.width * 35 / testScreenWidth,
            height: MediaQuery.of(context).size.height * 35 / testScreenHeight,
          ),
        ),
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    37.2 /
                    testScreenHeight,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 120,
                    left: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dasboardAddTraineeTitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: dashboardAddTraineeTitleYellowColor,
                          fontSize: ScreenUtil().setSp(
                            24,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            10 /
                            testScreenHeight,
                      ),
                      Text(
                        overflow: TextOverflow.ellipsis,
                        dashboardAddTraineeSubtitle,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(14),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height:
                    MediaQuery.of(context).size.height * 40 / testScreenHeight,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 36,
                  left: 29,
                ),
                child: Form(
                  key: _traineeFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (name) {
                          if (name == null || name.isEmpty) {
                            return dashboardInputNameEmptyTextField;
                          }
                          return null;
                        },
                        controller: _nameController,
                        cursorColor: dashboardAddTraineeHighlightGreenColor,
                        toolbarOptions: const ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                        ),
                        decoration: dashboardInputFieldDecoration(
                          dashboardAddTraineeNameHint,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            26 /
                            testScreenHeight,
                      ),
                      TextFormField(
                        validator: (surname) {
                          if (surname == null || surname.isEmpty) {
                            return dashboardInputSurnameEmptyTextField;
                          }
                          return null;
                        },
                        controller: _surnameController,
                        cursorColor: dashboardAddTraineeHighlightGreenColor,
                        toolbarOptions: const ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                        ),
                        decoration: dashboardInputFieldDecoration(
                          dashboardAddTraineeSurnameHint,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            26 /
                            testScreenHeight,
                      ),
                      TextFormField(
                        validator: (phoneNumber) {
                          if (phoneNumber == null || phoneNumber.isEmpty) {
                            return dashboardInputPhoneEmptyTextField;
                          }
                          return null;
                        },
                        controller: _phoneNumberController,
                        cursorColor: dashboardAddTraineeHighlightGreenColor,
                        toolbarOptions: const ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                        ),
                        decoration: dashboardInputFieldDecoration(
                          dashboardAddTraineePhoneHint,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            26 /
                            testScreenHeight,
                      ),
                      TextFormField(
                        validator: (traineeProgram) {
                          if (traineeProgram == null ||
                              traineeProgram.isEmpty) {
                            return dashboardInputProgramEmptyTextField;
                          }
                          return null;
                        },
                        controller: _traineeProgramController,
                        cursorColor: dashboardAddTraineeHighlightGreenColor,
                        toolbarOptions: const ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                        ),
                        decoration: dashboardInputFieldDecoration(
                          dashboardAddTraineeProgramHint,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            26 /
                            testScreenHeight,
                      ),
                      TextFormField(
                        validator: (traineeEmail) {
                          if (traineeEmail == null || traineeEmail.isEmpty) {
                            return dashboardInputEmailEmptyTextField;
                          } else if (!dashboardPresenter
                              .validateEmail(traineeEmail)) {
                            return dashboardInputEmailInvalidTextField;
                          }
                          return null;
                        },
                        controller: _traineeEmailController,
                        cursorColor: dashboardAddTraineeHighlightGreenColor,
                        toolbarOptions: const ToolbarOptions(
                          copy: true,
                          cut: true,
                          paste: true,
                        ),
                        decoration: dashboardInputFieldDecoration(
                          dashboardAddTraineeEmailHint,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            26 /
                            testScreenHeight,
                      ),
                      TextFormField(
                        validator: (dateValidator) {
                          if (dateValidator == null || dateValidator.isEmpty) {
                            return dashboardInputDateEmptyTextField;
                          }
                          return null;
                        },
                        controller: _dateTimeController,
                        cursorColor: dashboardAddTraineeHighlightGreenColor,
                        onTap: pickDateTime,
                        decoration: InputDecoration(
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
                          icon: const Icon(
                            Icons.calendar_today,
                            color: dashboardAddTraineeHighlightGreenColor,
                          ), // icon of text field
                          label: Text(
                            overflow: TextOverflow.ellipsis,
                            "Enter date and time",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(
                                14,
                              ),
                              color: dashboardAddTraineeInputFieldHintGreyColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height:
                    MediaQuery.of(context).size.height * 54 / testScreenHeight,
              ),
              GestureDetector(
                onTap: () async {
                  final isValid = _traineeFormKey.currentState!.validate();
                  if (!isValid) {
                    return;
                  }

                  // Find trainee to send offer
                  var traineeUID = await dashboardPresenter
                      .onfindTraineeByEmail(_traineeEmailController.text)
                      .onError(
                    (error, stackTrace) {
                      return;
                    },
                  );

                  // no trainee found, show a error message
                  if (traineeUID == null) {
                    Future(
                      () async {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                dashboard_ErrorAlertDialog_title,
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const [
                                    Text(
                                        overflow: TextOverflow.ellipsis,
                                        dashboard_NoUserFound_AlertDialog_title),
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: yellowColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    dashboard_AlertDialogButton_text,
                                    style: TextStyle(
                                      color: blackColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                    return;
                  }

                  var trainerId =
                      dashboardPresenter.getCurrentFirebaseUser()!.uid;
                  // create a map to load the offer
                  var traineeRegistrationOffer = TraineeeRegistrationOffer(
                    _nameController.text,
                    _surnameController.text,
                    _phoneNumberController.text,
                    _traineeProgramController.text,
                    false,
                    trainerId,
                    _dateTimeController.text,
                  ).toJson();

                  await dashboardPresenter
                      .onWriteOfferToTrainee(
                    traineeUID,
                    traineeRegistrationOffer,
                  )
                      .then(
                    (value) async {
                      Future(
                        () async {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  dashboard_AlertDialog_title,
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: const [
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        dashboard_MessageAlertDialog_OfferSentSuccessfully,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: yellowColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      dashboard_AlertDialogButton_text,
                                      style: TextStyle(
                                        color: blackColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                      return;
                    },
                  ).onError(
                    (error, stackTrace) {
                      return;
                    },
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                        "${imagePath}dashboard_sendTraineeInfo_btn.svg"),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      dashboardAddTraineeSendButtonText,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          16,
                        ),
                        fontWeight: FontWeight.bold,
                        color: dashboardAddTraineeSendButtonWhiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 17.5,
                  right: 42,
                  left: 40,
                ),
                child: Text.rich(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  TextSpan(
                    text:
                        scene_watchSignupScreen_signupScreen_termsAndConditions,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      color: dashboardAddTraineeTermsAndConditionsGreyColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: scene_seeTerms_signupScreen_inkWell,
                        style: dashboardAddTraineeLinkStyle,
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      TextSpan(
                        text: scene_watchSignupScreen_signupScreen_and,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            14,
                          ),
                          color: dashboardAddTraineeTermsAndConditionsGreyColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: scene_seeConditions_signupScreen_inkWell,
                            style: dashboardAddTraineeLinkStyle,
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
