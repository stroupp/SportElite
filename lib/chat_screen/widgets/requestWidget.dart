import 'dart:developer' as dev;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../interactor/interactor_chat.dart';
import '../../dashboard/dashboard_presenter.dart';
import '../../utils/constants.dart';

class requestComing extends StatefulWidget {
  String offerCompilation;
  String messageSenderID;
  String? currentID;

  requestComing({
    Key? key,
    required this.offerCompilation,
    required this.messageSenderID,
    required this.currentID,
  }) : super(key: key);

  @override
  State<requestComing> createState() => _requestComingState();
}

class _requestComingState extends State<requestComing> {
  InteractorChat interactorChat = InteractorChat();
  var isAccepted;
  double startPos = 20;
  double endPos = 160;
  var containerColor = yellowColor;
  bool isYes = false;
  bool isClicked = false;
  final _dashboardPresenter = DashboardPresenter();

  DashboardPresenter get dashboardPresenter => _dashboardPresenter;
  final usersCollectionFirebasePath = "users";
  final firestoreUserOffersPath = "registerOffers";
  final firestoreTrainerRegisteredTraineesPath = "registeredTrainees";
  final currentProgramPath = "currentProgram";
  late double hR;
  late double wR;

  @override
  Widget build(BuildContext context) {
    hR = MediaQuery.of(context).size.height / 797.71;
    wR = MediaQuery.of(context).size.width / 411.42;
    startPos *= wR;
    endPos *= wR;
    var asd = widget.offerCompilation.split("/");
    var offerID = asd[0];
    var userName = asd[1];

    return Container(
      decoration: BoxDecoration(
        color: yellowColor,
        borderRadius: widget.messageSenderID == widget.currentID
            ? const BorderRadius.only(
                bottomRight: Radius.circular(0),
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30))
            : const BorderRadius.only(
                bottomRight: Radius.circular(30),
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30)),
      ),
      height: 180 * hR,
      width: 250 * wR,
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 15 * hR, vertical: 15 * wR),
            child: Text(
              "${userName} has sent you a registration request.",
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(15),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8 * wR, vertical: 8 * hR),
            child: AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: containerColor,
              ),
              height: 80 * hR,
              width: 300 * wR,
              duration: const Duration(milliseconds: 500),
              child: Stack(children: [
                isAccepted != null
                    ? isAccepted
                        ? Positioned(
                            top: 30 * hR,
                            right: 150 * wR,
                            child: Text(
                              "Accepted!",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12 * wR),
                            ))
                        : Positioned(
                            top: 30 * hR,
                            left: 100 * wR,
                            child: Text(
                              "Denied!",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12 * wR),
                            ))
                    : Container(),
                AnimatedPositioned(
                  top: 10 * hR,
                  bottom: 10 * hR,
                  duration: const Duration(milliseconds: 500),
                  left: isAccepted == null
                      ? endPos
                      : isAccepted
                          ? endPos
                          : startPos,
                  child: AnimatedOpacity(
                    opacity: isClicked
                        ? !isYes
                            ? 1.0
                            : 0.0
                        : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: ClipPath(
                      clipper: regularHexagon(),
                      child: Container(
                        height: 60 * hR,
                        width: 60 * wR,
                        color: Colors.red,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: !isClicked
                              ? () {
                                  interactorChat.deleteRequestMessages(
                                      widget.messageSenderID,
                                      widget.currentID,
                                      "I deny your offer!");
                                  //TODO deny request
                                  setState(() {
                                    isYes = false;
                                    isClicked = true;
                                    containerColor = Colors.redAccent;
                                    isAccepted = false;
                                  });
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  top: 10 * hR,
                  bottom: 10 * hR,
                  duration: const Duration(milliseconds: 500),
                  left: isAccepted == null
                      ? startPos
                      : isAccepted
                          ? endPos
                          : startPos,
                  child: AnimatedOpacity(
                    opacity: isClicked
                        ? isYes
                            ? 1.0
                            : 0.0
                        : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: ClipPath(
                      clipper: regularHexagon(),
                      child: Container(
                        height: 60 * hR,
                        width: 60 * wR,
                        color: isAccepted == null
                            ? Colors.green
                            : isAccepted
                                ? Colors.green
                                : Colors.green.withOpacity(0),
                        child: IconButton(
                          icon: const Icon(Icons.check, color: Colors.white),
                          onPressed: !isClicked
                              ? () async {
                                  dev.log(
                                      "[offerID retrieved in requestWidget]: ${offerID}");
                                  //add the traineeID to the trainer registeredTrainees
                                  await dashboardPresenter
                                      .onRegisterTraineeToTrainer(
                                          widget.messageSenderID)
                                      .onError(
                                    (error, stackTrace) {
                                      return;
                                    },
                                  );

                                  //update offerStatus to true
                                  var offerStatus = true;
                                  await dashboardPresenter
                                      .onUpdateRegisterOfferStatus(
                                          offerStatus, offerID)
                                      .then(
                                    (res) {
                                      dev.log("[Register Offer Status]: $res");
                                    },
                                  ).onError(
                                    (error, stackTrace) {
                                      dev.log(
                                          "[Register Offer Status]: $error");
                                      return;
                                    },
                                  );
                                  var currentUserID =
                                      FirebaseAuth.instance.currentUser?.uid;

                                  var collection = await FirebaseFirestore
                                      .instance
                                      .collection(usersCollectionFirebasePath)
                                      .doc(currentUserID)
                                      .collection(firestoreUserOffersPath)
                                      .doc(offerID)
                                      .get()
                                      .then((value) {
                                    return value;
                                  });

                                  var offer = collection;

                                  var trainerId = offer.get("trainerId");
                                  // Register trainer to the trainee
                                  await dashboardPresenter
                                      .onRegisterTrainerToTrainee(trainerId)
                                      .onError(
                                    (error, stackTrace) {
                                      return;
                                    },
                                  );

                                  // set the current program to the offer
                                  var initialProgram = offer.get("program");
                                  var programDate = offer.get("date");
                                  await dashboardPresenter
                                      .onSetTraineeCurrentProgram(
                                          initialProgram,
                                          widget.messageSenderID,
                                          programDate)
                                      .then(
                                    (res) async {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "You have successfully registered to $initialProgram",
                                          ),
                                        ),
                                      );
                                      await dashboardPresenter
                                          .onDeleteOffer(offerID);
                                    },
                                  );

                                  setState(() {
                                    isYes = true;
                                    isClicked = true;
                                    containerColor = Colors.greenAccent;
                                    isAccepted = true;
                                  });

                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    interactorChat.deleteRequestMessages(
                                        widget.messageSenderID,
                                        widget.currentID,
                                        "I accept your offer!");
                                  });
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 30 * wR,
                    child: AnimatedOpacity(
                      opacity: isClicked ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        child: Text(
                          "Accept",
                          style: TextStyle(fontSize: 14 * hR),
                        ),
                      ),
                    )),
                Positioned(
                    bottom: 0,
                    left: 175 * wR,
                    child: AnimatedOpacity(
                      opacity: isClicked ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: Text("Deny", style: TextStyle(fontSize: 14 * hR)),
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class regularHexagon extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(size.width * 0.25, 0);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width, size.height * sqrt(3) / 4);
    path.lineTo(size.width * 0.75, size.height * sqrt(3) / 2);
    path.lineTo(size.width * 0.25, size.height * sqrt(3) / 2);
    path.lineTo(0, size.height * sqrt(3) / 4);
    path.lineTo(size.width * 0.25, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
