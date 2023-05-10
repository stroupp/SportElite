import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sport_elite_app/choose_avatar_screen/entity/entity.dart';
import 'package:sport_elite_app/choose_avatar_screen/presenter/choose_avatar_presenter.dart'
    as pr;
import 'package:sport_elite_app/router/router.dart';
import '../../widgets/sport_app_rounded_button.dart';
import '../interactor/choose_avatar_interactor.dart';

enum ImageChooseState { notChoosed, choosedFromDefault, choosedfromGallery }

class ChooseAvatarPage extends StatefulWidget {
  late bool comingFromProfilePage;

  ChooseAvatarPage({Key? key, required this.comingFromProfilePage})
      : super(key: key);

  @override
  State<ChooseAvatarPage> createState() => _ChooseAvatarPageState();
}

class _ChooseAvatarPageState extends State<ChooseAvatarPage> {
  bool showSpinner = false;
  ImageChooseState imageChooseState = ImageChooseState.notChoosed;
  int chosenDefaultIndex = 0;
  final presenter = pr.ChooseAvatarPresenter();
  List<ImageWithLoc>? defImages;
  bool isDefsPicked = false;
  ScrollController defSC = ScrollController();

  //#region pick image file
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

//#endregion

  //#region get default images list

  Future setDefImages() async {
    defImages = await ChooseAvatarInteractor.getDefaultPPs();
    setState(() {
      isDefsPicked = true;
    });
  }

  //#endregion

  @override
  void initState() {
    setDefImages();
    super.initState();
  }

  bool isImageSelected = false;
  String placeHolderPath =
      '/data/user/0/com.example.sport_elite_app/cache/image_picker2567187321657157102.jpg';
  late var pickedImageFile = File(placeHolderPath);
  late String pickedImageLoc;

  StatefulWidget getStackImage() {
    switch (imageChooseState) {
      case ImageChooseState.notChoosed:
        return defImages![chosenDefaultIndex].image;
      case ImageChooseState.choosedFromDefault:
        if (chosenDefaultIndex == -1) chosenDefaultIndex = 0;
        return defImages![chosenDefaultIndex].image;
      case ImageChooseState.choosedfromGallery:
        if (pickedImageFile != null) {
          return Image.file(pickedImageFile);
        }
    }
    return Image.asset("assets/images/placeholders/user.png");
  }

  void setDefault(String imageLoc, int index) {
    setState(() {
      isImageSelected = true;
      imageChooseState = ImageChooseState.choosedFromDefault;
      pickedImageLoc = imageLoc;
      chosenDefaultIndex = index;
    });
  }

  void changeToPickedFromGallery(String? newPath) {
    setState(() {
      chosenDefaultIndex = -1;
      pickedImageFile = File('$newPath');
      imageChooseState = ImageChooseState.choosedfromGallery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.withOpacity(0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //#region Page Description
                widget.comingFromProfilePage
                    ? Text(
                        "Change Your Avatar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFFFFE241),
                          fontSize: ScreenUtil().setSp(
                            24,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        "Who are you?\n Choose your avatar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: const Color(0xFFFFE241),
                          fontSize: ScreenUtil().setSp(
                            24,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                widget.comingFromProfilePage
                    ? Text(
                        "Upload a picture or choose a default avatar\n that’s how students or trainer could\n recognize you",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ScreenUtil().setSp(
                            14,
                          ),
                        ),
                      )
                    : Text(
                        "Create a profile and upload a picture\n that’s how students or trainer could\n recognize you",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ScreenUtil().setSp(
                            14,
                          ),
                        ),
                      ),
                //#endregion
                const SizedBox(
                  height: 30,
                ),
                //#region Chosen Avatar Stack
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF373737),
                          ),
                          height: 152,
                          width: 141,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: !isImageSelected
                                    ? const Color(0xFFC4C4C4)
                                    : Colors.red.withOpacity(0),
                              ),
                              height: 120,
                              width: 120,
                              child: isDefsPicked
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: getStackImage(),
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(25.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.blue,
                                        strokeWidth: 1,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'That’s you',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(10),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          widget.comingFromProfilePage
                              ? GestureDetector(
                                  child: Container(
                                    height: 30,
                                    color: Colors.red.withOpacity(0),
                                    child: Text(
                                      'Change',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF6CAE97),
                                        fontSize: ScreenUtil().setSp(10),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    openBottomSheet(context);
                                  },
                                )
                              : GestureDetector(
                                  child: Container(
                                    height: 30,
                                    color: Colors.red.withOpacity(0),
                                    child: Text(
                                      !isImageSelected ? 'Choose Now' : 'Change',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF6CAE97),
                                        fontSize: ScreenUtil().setSp(
                                          10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    openBottomSheet(context);
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                //#endregion
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Or choose from \n the default",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 10,
                    ),
                    SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: isDefsPicked
                          ? ListView.builder(
                              controller: defSC,
                              itemCount: defImages!.length - 1,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return pickDefaultContainer(
                                  image: defImages![index + 1].image,
                                  index: index + 1,
                                  selectedIndex: chosenDefaultIndex,
                                  setD: setDefault,
                                  imageLoc: defImages![index + 1].loc,
                                );
                              },
                            )
                          : const Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  strokeWidth: 1,
                                ),
                              ),
                            ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    widget.comingFromProfilePage
                        ? SportAppRoundedButton(
                            heightRatio: 13,
                            textStyle: const TextStyle(),
                            widthRatio: 390 / 154,
                            buttonColor: Colors.white,
                            inputText: 'CANCEL',
                            borderColor: Colors.black,
                            customOnPressed: () {
                              Navigator.pop(context);
                            })
                        : SportAppRoundedButton(
                            heightRatio: 13,
                            textStyle: const TextStyle(),
                            widthRatio: 390 / 154,
                            buttonColor: Colors.white,
                            inputText: 'SKIP',
                            borderColor: Colors.black,
                            customOnPressed: isDefsPicked
                                ? () async {
                                    setState(() {
                                      showSpinner = true;
                                    });

                                    await pr.ChooseAvatarPresenter.confirmWithDef(
                                        defImages![0].loc);

                                    setState(() {
                                      showSpinner = false;
                                    });
                                    navigateToDashboard(context);
                                  }
                                : null,
                          ),
                    SportAppRoundedButton(
                      heightRatio: 13,
                      textStyle: const TextStyle(),
                      widthRatio: 390 / 154,
                      buttonColor: const Color(0xFFFFE241),
                      inputText: 'CONFIRM',
                      borderColor: const Color(0xFFFFE241),
                      customOnPressed: imageChooseState !=
                              ImageChooseState.notChoosed
                          ? isDefsPicked
                              ? () async {
                                  setState(() {
                                    showSpinner = true;
                                  });

                                  if (imageChooseState ==
                                      ImageChooseState.choosedfromGallery) {
                                    await pr.ChooseAvatarPresenter
                                        .confirmWithFile(pickedImageFile);
                                  }
                                  if (imageChooseState ==
                                      ImageChooseState.choosedFromDefault) {
                                    await pr.ChooseAvatarPresenter.confirmWithDef(
                                        pickedImageLoc);
                                  }
                                  if (imageChooseState ==
                                      ImageChooseState.notChoosed) {
                                    await pr.ChooseAvatarPresenter.confirmWithDef(
                                        defImages![chosenDefaultIndex].loc);
                                  }

                                  if (widget.comingFromProfilePage) {
                                    Navigator.pop(context);
                                  } else {
                                    navigateToDashboard(context);
                                  }
                                  //after all add a field with image link to the users list with corresponding uid
                                }
                              : null
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class pickDefaultContainer extends StatelessWidget {
  Image image;
  int index;
  int selectedIndex;
  Function setD;
  String imageLoc;

  pickDefaultContainer(
      {Key? key,
      required this.image,
      required this.index,
      required this.selectedIndex,
      required this.setD,
      required this.imageLoc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 51,
        width: 51,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.red.withOpacity(0),
            border: Border.all(
                color: index == selectedIndex
                    ? Colors.green
                    : Colors.green.withOpacity(0),
                width: 1.5)),
        child: Center(
          child: GestureDetector(
            onTap: () {
              //set default
              setD(imageLoc, index);
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFC4C4C4),
              ),
              child: image,
            ),
          ),
        ),
      ),
    );
  }
}
