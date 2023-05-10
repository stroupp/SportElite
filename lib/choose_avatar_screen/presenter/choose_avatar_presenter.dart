import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/constants.dart';
import '../interactor/choose_avatar_interactor.dart';

class ChooseAvatarPresenter extends ChooseAvatarInteractor {
  static Future confirmWithFile(File? pickedImageFile) async {
    await ChooseAvatarInteractor.uploadFile(pickedImageFile!);
  }

  static Future confirmWithDef(String defLoc) async {
    //set the users pp path to defloc
    ChooseAvatarInteractor.setPPDefLoc(defLoc);
  }

  static Future<File> getImageFileFromAssets(String path) async {
    print("path:assets/$path");
    final byteData = await rootBundle.load('assets/$path');

    File file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}

class BottomSheet extends StatelessWidget {
  Function pickImage;

  BottomSheet({
    Key? key,
    required this.pickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            )),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 12),
                child: Text(
                  "Profile photo",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(
                      20,
                    ),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            pickImage(true);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side: const BorderSide(
                                        color: yellowColor, width: 2))),
                            elevation: MaterialStateProperty.all(0),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(10)),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.blue.withOpacity(0)),
                            // <-- Button color
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return yellowColor;
                              } // <-- Splash color
                            }),
                          ),
                          child: const Icon(
                            Icons.image,
                            color: yellowColor,
                            size: 40,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                          )),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            pickImage(false);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side: const BorderSide(
                                        color: yellowColor, width: 2))),
                            elevation: MaterialStateProperty.all(0),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(10)),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.blue.withOpacity(0)),
                            // <-- Button color
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                    (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return yellowColor;
                              } // <-- Splash color
                            }),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: yellowColor,
                            size: 40,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            "Camera",
                            textAlign: TextAlign.center,
                          )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
