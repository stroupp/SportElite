import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport_elite_app/choose_avatar_screen/presenter/choose_avatar_presenter.dart'
    as pr;
import 'package:sport_elite_app/router/router.dart';
import '../../choose_avatar_screen/entity/entity.dart';
import '../../choose_avatar_screen/interactor/choose_avatar_interactor.dart';
import '../../choose_avatar_screen/view/choose_avatar_page.dart';
import '../../utils/constants.dart';
import '../interactor/profile_edit_interactor.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  TextEditingController username = TextEditingController();
  TextEditingController aboutMe = TextEditingController();
  TextEditingController interests = TextEditingController();
  TextEditingController university = TextEditingController();
  TextEditingController speciality = TextEditingController();
  TextEditingController company = TextEditingController();

  ProfileEditInteractor profileEditInteractor = ProfileEditInteractor();

  bool showSpinner = false;
  ImageChooseState imageChooseState = ImageChooseState.notChoosed;
  int chosenDefaultIndex = 0;
  final presenter = pr.ChooseAvatarPresenter();
  List<ImageWithLoc>? defImages;
  bool isDefsPicked = false;
  ScrollController defSC = ScrollController();

  bool isImageSelected = false;
  String placeHolderPath =
      '/data/user/0/com.example.sport_elite_app/cache/image_picker2567187321657157102.jpg';
  late var pickedImageFile = File(placeHolderPath);
  late String pickedImageLoc;

  void openBottomSheet(var context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: pr.BottomSheet(
              pickImage: pickImageFile,
            )),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  void pickImageFile(bool isFromGallery) async {
    File newImage;
    if (isFromGallery) {
      newImage = (await ChooseAvatarInteractor.pickImageGallery())!;
    } else {
      newImage = (await ChooseAvatarInteractor.pickImageCamera())!;
    }

    if (newImage != null) {
      setState(() {
        chosenDefaultIndex = -1;
        imageChooseState = ImageChooseState.choosedfromGallery;
        pickedImageFile = newImage;
        isImageSelected = true;
      });
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    bool isImageChose = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(
              20,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await profileEditInteractor.editProfileInfo(context, username,
                  aboutMe, interests, university, speciality, company);
            },
            icon: const Icon(
              Icons.check,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            username.text = snapshot.data?.docs[0].get("username");
            aboutMe.text = snapshot.data?.docs[0].get("aboutMe");
            interests.text = snapshot.data?.docs[0].get("interests");
            university.text = snapshot.data?.docs[0].get("university");
            speciality.text = snapshot.data?.docs[0].get("speciality");
            company.text = snapshot.data?.docs[0].get("company");
            return SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: FutureBuilder(
                        future: profileEditInteractor.getUserAvatarUrl(
                            FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, AsyncSnapshot<String> ppSnapshot) {
                          if (!ppSnapshot.hasData) {
                            return const Center(
                              child: Text(
                                'No avatar picture found',
                                style: TextStyle(
                                  color: messagingTitleWhiteColor,
                                ),
                              ),
                            );
                          }
                          return Image.network(ppSnapshot.data!);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () async {
                        navigateToAvatarPage(context, true);
                      },
                      child: Text(
                        "Change profile photo",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: ScreenUtil().setSp(
                            18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: username,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            16,
                          ),
                          color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: "Username",
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
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: aboutMe,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            16,
                          ),
                          color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: "About Me",
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
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: interests,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: "Interests",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(16),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: university,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            16,
                          ),
                          color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: "University",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(16),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: speciality,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: "Speciality",
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
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: company,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: "Company",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(
                            16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
