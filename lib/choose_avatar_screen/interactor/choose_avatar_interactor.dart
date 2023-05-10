import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:sport_elite_app/choose_avatar_screen/entity/entity.dart';
import '../../utils/shared_preferences_helper.dart';

class ChooseAvatarInteractor {
  static Future<File?> pickImageGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;
    if (cropImage == null) {
      return File(pickedFile.path);
    } else {
      final file = File(pickedFile.path);
      CroppedFile? croppedFile = await cropImage(file);
      var p = croppedFile!.path;
      return await File(p);
    }
  }

  static Future<File?> pickImageCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return null;
    if (cropImage == null) {
      return File(pickedFile.path);
    } else {
      final file = File(pickedFile.path);
      CroppedFile? croppedFile = await cropImage(file);
      var p = croppedFile!.path;
      return await File(p);
    }
  }

  static Future<CroppedFile?> cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );
    return croppedFile;
  }

  /// The user selects a file, and the task is added to the list.
  static Future uploadFile(File file) async {
    String uid = await SharedPreferencesHelper.getUID();
    File renamedFile = await changeFileName(file, uid);

    String fileName = basename(renamedFile.path);

    final firePath = 'profile_pictures/$fileName';

    final ref = FirebaseStorage.instance.ref().child(firePath);
    final bucket = FirebaseStorage.instance.ref().child(firePath).bucket;
    String loc = 'gs://$bucket/$firePath';
    var uploadTask = await ref.putFile(renamedFile);
    String downloadURL = await ref.getDownloadURL();
    await setPPDefLoc(loc);

    return null;
  }

  static Future<File> changeFileName(File file, String newFileName) async {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;

    if (newPath != path) {
      return file.rename(newPath);
    } else {
      return file;
    }
  }

  /// Sets an index to the current user's profile picture,
  /// so it can be retrieved later. (-1 for no selection)
  static Future? setPPDefLoc(String loc) async {
    final _firestore = FirebaseFirestore.instance;
    String uid = await SharedPreferencesHelper.getUID();

    //find the doc with the current user's id.
    try {
      var document = await _firestore
          .collection('users')
          .doc(uid)
          .update({'pp_path': loc});
      String downloadUrl = await getUrlWithLoc(loc);

      var document2 = await _firestore
          .collection('users')
          .doc(uid)
          .update({'pp_url': downloadUrl});

      return null;
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  /// Gets an index to the current user's profile picture.
  ///(-1 for no selection)
  static Future<int> getPPImageIndex() async {
    final _firestore = FirebaseFirestore.instance;
    try {
      String uid = await SharedPreferencesHelper.getUID();
      var document = await _firestore.collection('users').doc(uid).get();
      DocumentSnapshot<Map<String, dynamic>> data = document;

      var index = data["def_pp_index"];

      return index;
    } catch (e) {
      log(e.toString());
    }

    return -1;
  }

  static Future<int> getDefsLength() async {
    final _firestore = FirebaseFirestore.instance;
    var document = await _firestore
        .collection('default_pps_map')
        .doc('index_path_map')
        .get();
    DocumentSnapshot<Map<String, dynamic>> data = document;

    Map dataMap = data['map'];
    int length = dataMap.length;
    return length;
  }

  static Future<List<ImageWithLoc>> getDefaultPPs() async {
    final _firestore = FirebaseFirestore.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;
    List<ImageWithLoc> default_pp_images_withLoc = [];

    //get index_path_map from firestore

    var document = await _firestore
        .collection('default_pps_map')
        .doc('index_path_map')
        .get();
    DocumentSnapshot<Map<String, dynamic>> data = document;

    Map dataMap = data['map'];
    int length = dataMap.length;
    for (int i = 0; i < length; i++) {
      String imageLoc = dataMap[i.toString()];
      //4 th image loc is : gs://sport-elite-688f7.appspot.com/default_pictures/placeholder_3.png
      //"profile_pictures/$uid"
      List<String> splitted = imageLoc.split('/');
      String imageName = splitted[4];

      String imgURL = await getUrlWithLoc(imageLoc);

      var img = Image.network(imgURL);
      var imgL = new ImageWithLoc(image: img, loc: imageLoc);
      default_pp_images_withLoc.add(imgL);
    }
    return default_pp_images_withLoc;
  }

  static Future<String> getUrlWithLoc(String loc) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    List<String> splitted = loc.split('/');
    //start from index 3 add all after together

    String location = "";
    for (int i = 3; i < splitted.length; i++) {
      location += splitted[i];
      if (i != splitted.length - 1) location += "/";
    }

    String imgURL = await storage.ref().child(location).getDownloadURL();
    return imgURL;
  }
}
