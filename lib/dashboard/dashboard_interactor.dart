import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sport_elite_app/chat_screen/interactor/interactor_chat.dart';
import 'package:sport_elite_app/home_screen/interactor/home_screen_interactor.dart';
import 'dart:developer' as dev;
import '../utils/constants.dart';
import 'package:uuid/uuid.dart';

const usersCollectionFirebasePath = "users";
const firestoreUserOffersPath = "registerOffers";
const firestoreTrainerRegisteredTraineesPath = "registeredTrainees";
const firestoreTraineeRegisteredTrainersPath = "registeredTrainers";
const currentProgramPath = "currentProgram";

var myCurrentUser = FirebaseAuth.instance.currentUser;
InteractorChat interactorChat = InteractorChat();

class DashboardInteractor implements IFirebaseUser {
  // Get the username of the current user
  Stream getFirebaseUsername() {
    String currentUserID = getCurrentFirebaseUser()!.uid;
    return FirebaseFirestore.instance
        .collection(dashboardFirestoreUsersCollection)
        .doc(currentUserID)
        .snapshots();
  }

  // Get current Firebase user
  @override
  User? getCurrentFirebaseUser() {
    try {
      return FirebaseAuth.instance.currentUser!;
    } on FirebaseAuthException catch (e) {
      dev.log(
        "[Dashboard Interactor]",
        error: e,
      );
    }
    return null;
  }

  // Send signout request to Firebase for the user
  void signOutFirebaseUser() => FirebaseAuth.instance.signOut();

  // Find the trainee of the given email from Firestore
  Future<String?> findTraineeByEmailFromFirestore(String email) async {
    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .where("email", isEqualTo: email)
        .get()
        .onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor] Find Trainee by Email",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("No users found from Firebase");
      },
    );
    return res.docs.isEmpty ? null : res.docs.first.id;
  }

  // Find the user by the given id in Firestore
  Future<Map<String, dynamic>> findUserById(String uId) async {
    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .where("uid", isEqualTo: uId)
        .get()
        .onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor] Find User by ID",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("No users found from Firebase");
      },
    );
    return res.docs.isEmpty
        ? {
            "response": "User document is empty",
          }
        : res.docs.first.data();
  }

  // Create a new offer for the given trainee in Firestore
  Future<String> writeOfferToFirestore(
      String userId, Map<String, dynamic> offer) async {
    var offerID = const Uuid().v4().substring(1, 7);

    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(userId)
        .collection(firestoreUserOffersPath)
        .doc(offerID)
        .set(offer)
        .then(
      (_) {
        interactorChat.counterHandle(userId, myCurrentUser!.uid);
        offerID = "$offerID/${myCurrentUser!.email}";
        interactorChat.sendMessage(userId, myCurrentUser!.uid, offerID,
            myCurrentUser!.uid, "request", interactorChat.getCounter());
        interactorChat.counterHandle(userId, myCurrentUser!.uid);

        return offerID;
      },
    ).onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor]",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("Error sending offer");
      },
    );
    return res.isEmpty ? "Offer document is empty" : res;
  }

  // Register trainee to the trainer in Firestore
  Future registerTraineeToTrainer(String trainerId) async {
    var currentTraineeId = getCurrentFirebaseUser()!.uid;

    var registerTraineeMap = {
      "traineeId": currentTraineeId,
    };

    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(trainerId)
        .collection(firestoreTrainerRegisteredTraineesPath)
        .doc(currentTraineeId)
        .set(registerTraineeMap)
        .then(
      (_) {
        return "Trainee registered successfully";
      },
    ).onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor]",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("Error registering trainee");
      },
    );
    return res.isEmpty ? "Trainee document is empty" : res;
  }

  // Register trainee to the trainer in Firestore
  Future registerTrainerToTrainee(String trainerId) async {
    var currentTraineeId = getCurrentFirebaseUser()!.uid;

    var registerTrainerMap = {
      "trainerId": trainerId,
    };

    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(currentTraineeId)
        .collection(firestoreTraineeRegisteredTrainersPath)
        .doc(trainerId)
        .set(registerTrainerMap)
        .then(
      (_) {
        return "Trainer registered successfully";
      },
    ).onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor] Registering Trainer to Trainee failed",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("Error registering trainer");
      },
    );
    return res.isEmpty ? "Trainer document is empty" : res;
  }

  // Get the list of offers for the current user
  Stream<QuerySnapshot> getTraineeRequestOffersFromFirestore() {
    var currentUserID = getCurrentFirebaseUser()!.uid;

    return FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(currentUserID)
        .collection(firestoreUserOffersPath)
        .snapshots();
  }

  // Delete the offer from Firestore for the current user
  Future deleteTrainerOfferFromFirestore(String docId) async {
    var currentUserID = getCurrentFirebaseUser()!.uid;

    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(currentUserID)
        .collection(firestoreUserOffersPath)
        .doc(docId)
        .delete()
        .then(
      (_) {
        return "Offer removed successfully";
      },
    ).onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor]: Offer Delete Request",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("Error deleting offer");
      },
    );

    return res.isEmpty ? "Trainee document is empty" : res;
  }

  // Update the register offerStatus to accepted or rejected in Firestore
  Future updateRegisterOfferStatusInFirestore(
      bool offerStatus, String offerId) async {
    var currentUserID = getCurrentFirebaseUser()!.uid;

    var offerStatusMap = {
      "offerStatus": offerStatus,
    };

    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(currentUserID)
        .collection(firestoreUserOffersPath)
        .doc(offerId)
        .update(offerStatusMap)
        .then(
      (_) {
        return "Offer status updated successfully";
      },
    ).onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor]: Offer Status Update Request",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("Error updating offer status");
      },
    );
    return res.isEmpty ? "Trainee document is empty" : res;
  }

  // Initially set the current program of the trainee in Firestore
  Future setTraineeCurrentProgram(
      String program, String trainerId, String date) async {
    var currentUserID = getCurrentFirebaseUser()!.uid;

    var programMap = {
      "currentProgram": {
        "name": program,
        "trainer": trainerId,
        "date": date,
      },
    };

    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(currentUserID)
        .set(programMap, SetOptions(merge: true))
        .then(
      (_) {
        return "Program updated successfully";
      },
    ).onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor]: Program Update Request",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("Error updating program");
      },
    );
    return res.isEmpty ? "Trainee document is empty" : res;
  }

  // Get the registered trainees for the current trainer from Firestore
  Stream<QuerySnapshot> getRegisteredTraineesFromFirestore() {
    var currentUserID = getCurrentFirebaseUser()!.uid;

    return FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(currentUserID)
        .collection(firestoreTrainerRegisteredTraineesPath)
        .snapshots();
  }

   // Get the registered trainees for the current trainer from Firestore
  Stream<QuerySnapshot> getRegisteredTrainersFromFirestore() {
    var currentUserID = getCurrentFirebaseUser()!.uid;

    return FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(currentUserID)
        .collection(firestoreTraineeRegisteredTrainersPath)
        .snapshots();
  }

  Future getRegisteredTraineesForTrainerNextProgram() async {
    var currentUserID = getCurrentFirebaseUser()!.uid;
    var res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(currentUserID)
        .collection(firestoreTrainerRegisteredTraineesPath)
        .get()
        .onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor]",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("Error getting registered trainees");
      },
    );
    return res.docs.isEmpty
        ? {
            "response": "Registered trainees document is empty",
          }
        : res.docs.map(
            (doc) {
              return doc.data();
            },
          ).toList();
  }

  // Get the profile picture of the given uid
  Future<String> getUserAvatarUrl(String uid) async {
    final res = await HomeScreenInteractor.getPpUrlOfUser(uid).onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor]",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("Error getting user avatar url");
      },
    );
    return res.isEmpty ? "User avatar url is empty" : res;
  }

  // Get the program of the current trainee from Firestore
  Future getTraineeNextProgram() async {
    var currentUserID = getCurrentFirebaseUser()!.uid;

    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(currentUserID)
        .get()
        .then(
      (val) {
        if (val.exists) {
          return val.get(currentProgramPath);
        } else {
          return "No program found";
        }
      },
    ).onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor]: Program Get Request",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("Error getting program");
      },
    );
    return res;
  }

  // Get the curernt user type from Firestore
  Future getCurrentUserType() async {
    var currentUserID = getCurrentFirebaseUser()!.uid;

    var firestoreCurrentUserTypePath = "usertype";

    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(currentUserID)
        .get()
        .then(
      (val) {
        if (val.exists) {
          return val.get(firestoreCurrentUserTypePath);
        } else {
          return "No user type found";
        }
      },
    ).onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor]: User Type Get Request",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("Error getting user type");
      },
    );
    return res;
  }

  // Delete the registered trainee of a trainer from Firestore
  Future deleteRegisteredTrainee(String docId) async {
    var currentTrainerId = getCurrentFirebaseUser()!.uid;

    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(currentTrainerId)
        .collection(firestoreTrainerRegisteredTraineesPath)
        .doc(docId)
        .delete()
        .then(
      (_) {
        return "Registered Trainee removed successfully";
      },
    ).onError(
      (error, stackTrace) {
        return Future.error("Error deleting registered trainee");
      },
    );
    return res.isEmpty ? "Registered Trainee document is empty" : res;
  }

  // Delete the registered trainee of a trainer from Firestore
  Future deleteRegisteredTrainer(String docId, String traineeID) async {
    var currentTrainerId = getCurrentFirebaseUser()!.uid;

    final docRef  = FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(traineeID);

    final updates = <String, dynamic>{
      "currentProgram": FieldValue.delete(),
    };

    docRef.update(updates);

    final res = await FirebaseFirestore.instance
        .collection(usersCollectionFirebasePath)
        .doc(traineeID)
        .collection(firestoreTraineeRegisteredTrainersPath)
        .doc(docId)
        .delete()
        .then(
      (_) {
        return "Registered Trainer removed successfully";
      },
    ).onError(
      (error, stackTrace) {
        return Future.error("Error deleting registered trainer");
      },
    );
    return res.isEmpty ? "Registered Trainer document is empty" : res;
  }
}
