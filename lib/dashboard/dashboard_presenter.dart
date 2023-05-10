import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sport_elite_app/authentication_screen/authentication_type/interactor/authentication_type_interactor.dart';
import 'package:sport_elite_app/authentication_screen/email_signin/presenter/email_signin_presenter.dart';
import 'package:sport_elite_app/dashboard/dashboard_interactor.dart';

import '../router/router.dart';

abstract class IFirebaseSignOut {
  void signOut(BuildContext context);
}

class DashboardPresenter implements IValidateEmail, IFirebaseSignOut {
  // MEMBERS
  final _dashboardInteractor = DashboardInteractor();
  final _authenticationTypeInteractor = AuthenticationTypeInteractor();

  //GETTERS
  DashboardInteractor get dashboardInteractor => _dashboardInteractor;

  AuthenticationTypeInteractor get authenticationTypeInteractor =>
      _authenticationTypeInteractor;

  // METHODS
  User? getCurrentFirebaseUser() {
    return dashboardInteractor.getCurrentFirebaseUser();
  }

  Stream getFirebaseUsername() {
    if (FirebaseAuth.instance.currentUser != null) {
      return dashboardInteractor.getFirebaseUsername();
    }
    return Stream.error('No current user found!');
  }

  // Signout from Firebase
  @override
  void signOut(BuildContext context) {
    if (authenticationTypeInteractor.userObj != null) {
      authenticationTypeInteractor.logOutFromFacebook();
      navigateToLoginTypePage(context);
    } else if (FirebaseAuth.instance.currentUser != null) {
      dashboardInteractor.signOutFirebaseUser();
      navigateToLoginTypePage(context);
    }
  }

  // Validate email address
  @override
  bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }

  // Called to find the trainee by the given email in Firestore
  Future onfindTraineeByEmail(String? email) async {
    if (email == null) {
      return Future.error(
        "Email is null",
      );
    }
    return dashboardInteractor.findTraineeByEmailFromFirestore(email);
  }

  // Called when the trainer sends offer to a trainee
  Future onWriteOfferToTrainee(String? userId, Map<String, dynamic>? offer) {
    if (userId == null) {
      return Future.error(
        "UserId is null",
      );
    } else if (offer == null) {
      return Future.error(
        "Offer is null",
      );
    }
    return dashboardInteractor.writeOfferToFirestore(userId, offer);
  }

  // Called when the offers for a trainee are fetched from Firestore
  Stream<QuerySnapshot> onGetTraineeRequestOffers() {
    return dashboardInteractor.getTraineeRequestOffersFromFirestore();
  }

  // Called when the trainer declines an offer
  Future onDeleteOffer(String? offerId) {
    if (offerId == null) {
      return Future.error(
        "OfferId is null",
      );
    }
    return dashboardInteractor.deleteTrainerOfferFromFirestore(offerId);
  }

  // Called when the trainer info requested
  Future<Map<String, dynamic>> onGetUserInfo(String? userId) {
    if (userId == null) {
      return Future.error(
        "UserId is null",
      );
    }
    return dashboardInteractor.findUserById(userId);
  }

  // Called when the trainee accepts a register offer
  Future onRegisterTraineeToTrainer(String? trainerId) async {
    if (trainerId == null) {
      return Future.error(
        "TrainerId is null",
      );
    }
    return dashboardInteractor.registerTraineeToTrainer(trainerId);
  }

  // Called when the trainee accepts a register offer
  Future onRegisterTrainerToTrainee(String? trainerId) async {
    if (trainerId == null) {
      return Future.error(
        "TrainerId is null",
      );
    }
    return dashboardInteractor.registerTrainerToTrainee(trainerId);
  }

  // Called when the trainee responds to a trainer offer
  Future onUpdateRegisterOfferStatus(bool? status, String? offerId) async {
    if (offerId == null) {
      return Future.error(
        "OfferId is null",
      );
    } else if (status == null) {
      return Future.error(
        "Status is null",
      );
    }
    return dashboardInteractor.updateRegisterOfferStatusInFirestore(
        status, offerId);
  }

  // Called when the current program of the trainee is modified
  Future onSetTraineeCurrentProgram(
      String? program, String? trainerId, String? date) async {
    if (program == null) {
      return Future.error(
        "ProgramId is null",
      );
    } else if (trainerId == null) {
      return Future.error(
        "TrainerId is null",
      );
    } else if (date == null) {
      return Future.error(
        "Date is null",
      );
    }
    return dashboardInteractor.setTraineeCurrentProgram(
        program, trainerId, date);
  }

  // Called when the registered trainees are fetched from Firestore
  Stream<QuerySnapshot> onGetRegisteredTrainees() {
    return dashboardInteractor.getRegisteredTraineesFromFirestore();
  }

  // Called when the registered trainees are fetched from Firestore
  Stream<QuerySnapshot> onGetRegisteredTrainers() {
    return dashboardInteractor.getRegisteredTrainersFromFirestore();
  }

  // Called when the trainee avatar is fetched from Firestore
  Future<String> onGetUserAvatarUrl(String? uid) async {
    if (uid == null) {
      return Future.error(
        "UserId is null",
      );
    }
    return dashboardInteractor.getUserAvatarUrl(uid);
  }

  // Called when the trainee program is fetched from Firestore
  Future onGetTraineeNextProgram() async {
    return dashboardInteractor.getTraineeNextProgram();
  }

  // Called when the trainer program is fetched from Firestore
  Future onGetTrainerNextProgram() async {
    // Get next program date from trainee data
    List<Map<String, dynamic>> traineeWeeksList = [];
    final trainerNextProgram = await dashboardInteractor
        .getRegisteredTraineesForTrainerNextProgram()
        .then(
      (val) async {
        if (val.isEmpty) {
          return Future.error("No trainee registered");
        } else if (val == null) {
          return Future.error("Null Exception for trainee registered");
        } else if (val.length == 0) {
          return Future.error("No trainee registered");
        }
        try {
          for (var traineeItem in val) {
            if (traineeItem == null) {
              return "No element found";
            }
            final traineeData = await onGetUserInfo(traineeItem["traineeId"]);
            var programDate = traineeData["currentProgram"]["date"];
            // Parse date to calculate difference from now
            var parsedProgramDate = parseProgramDate(programDate);
            // Calculate difference from now
            var programDateDifferenceInDays =
                calculateProgramDateDifference(parsedProgramDate);
            // Convert days to weeks
            var programDateWeeks =
                convertDaysToWeeks(programDateDifferenceInDays);
            // Add trainee id and weeks to sort
            addTraineeToProgramList(traineeWeeksList, traineeData,
                programDateWeeks, programDateDifferenceInDays);
          }
        } catch (e) {}

        if (traineeWeeksList.isEmpty) {
          return Future.error("Trainer has no trainee registered");
        }

        // Sort trainee list by weeks to get upcoming program for trainer
        var sortedTraineeWeeksList = orderTraineesByDays(traineeWeeksList);
        // Get the upcoming program
        var upcomingProgramTrainee = sortedTraineeWeeksList.first;

        var upcomingProgramTraineeData =
            await onGetUserInfo(upcomingProgramTrainee["id"]);
        var programmeTime =
            upcomingProgramTraineeData["currentProgram"]["date"].split("–");
        String programmeDate = programmeTime[0];
        String programmeHour = programmeTime[1];
        final upcomingProgram = {
          "traineeUsername": upcomingProgramTraineeData["username"],
          "programName": upcomingProgramTraineeData["currentProgram"]["name"],
          "programDate": programmeDate + programmeHour
        };
        return upcomingProgram;
      },
    ).onError(
      (error, stackTrace) {},
    );

    return trainerNextProgram;
  }

  List<Map<String, dynamic>> addTraineeToProgramList(
    List<Map<String, dynamic>> list,
    dynamic traineeData,
    int programDateWeeks,
    int programDateDifferenceInDays,
  ) {
    var traineeUid = traineeData["uid"];
    var traineeWeeksListEntry = {
      "id": traineeUid,
      "weeks": programDateWeeks,
      "days": programDateDifferenceInDays,
    };
    list.add(traineeWeeksListEntry);
    return list;
  }

  // Order the trainees by the number of weeks in the program
  List<Map<String, dynamic>> orderTraineesByDays(
      List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return list;
    }
    list.sort(
      (a, b) {
        return a["days"] - b["days"];
      },
    );
    return list;
  }

  // Called when the current user type is fetched from Firestore
  Future getCurrentUserType() async {
    return dashboardInteractor.getCurrentUserType();
  }

  // Parse the program date to a DateTime object
  DateTime? parseProgramDate(String date) {
    try {
      String year = date.substring(0, 4);
      String month = date.substring(5, 7);
      String day = date.substring(8, 10);
      String hour = date.substring(13, 15);
      String minute = date.substring(16, 18);
      return DateTime(int.parse(year), int.parse(month), int.parse(day),
          int.parse(hour), int.parse(minute));
    } catch (e) {
      return null;
    }
  }

  // Calculates the difference between now and the program date in days
  int calculateProgramDateDifference(DateTime? date) {
    if (date == null) -1;
    var now = DateTime.now();
    var diff = date!.difference(now).inDays;
    return diff;
  }

  // Converts the difference between now and the program date in days to weeks
  int convertDaysToWeeks(int days) {
    var weeks = (days / 7).ceil();
    if (weeks < 0) return 0;
    if (weeks == 0) return 1;
    return weeks;
  }

  // Called on delete a registered trainee from Firestore request
  Future onDeleteRegisteredTrainee(String? traineeId) async {
    if (traineeId == null) {
      return Future.error(
        "TraineeId is null",
      );
    }
    return dashboardInteractor.deleteRegisteredTrainee(traineeId);
  }

  // Called on delete a registered trainee from Firestore request
  Future onDeleteRegisteredTrainer(String? trainerId, String? traineeID) async {
    if (trainerId == null) {
      return Future.error(
        "TrainerId is null",
      );
    }
    if (traineeID == null) {
      return Future.error(
        "TrainerId is null",
      );
    }
    return dashboardInteractor.deleteRegisteredTrainer(trainerId, traineeID);
  }
}
