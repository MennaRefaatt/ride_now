import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/helpers/shared_pref.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../../../../core/theming/styles.dart';
import '../../../../generated/l10n.dart';

class UserImage extends StatefulWidget {
  const UserImage({super.key, required this.isChanged});
final bool isChanged;
  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? _imageFile;
  String? _downloadUrl;
  final String defaultPictureUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqYbbXz3X39dKJ66kFCx7_cQjqnujyfjXI1g&s";

  @override
  void initState() {
    super.initState();
    _fetchUserProfileImage(); // ✅ Fetch user profile image from Firestore
  }

  /// ✅ Fetch user profile image from Firestore
  Future<void> _fetchUserProfileImage() async {
    String userId = SharedPref.getString(key: MySharedKeys.userId) ?? "";

    if (userId.isNotEmpty) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String? photoUrl = userDoc['photoUrl'];
        if (photoUrl != null && photoUrl.isNotEmpty) {
          setState(() {
            _downloadUrl = photoUrl;
          });
        }
      }
    }
  }

  /// ✅ Allow user to pick an image from camera or gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S().pickImage),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final file = await picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, file);
              },
              child: Text(S().camera),
            ),
            TextButton(
              onPressed: () async {
                final file =
                await picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, file);
              },
              child: Text(S().gallery),
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      await _uploadImage();
    }
  }

  /// ✅ Uploads the selected image to Firebase Storage
  Future<void> _uploadImage() async {
    try {
      if (_imageFile == null) return;

      String filePath =
          'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(filePath);

      UploadTask uploadTask = ref.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;

      String imageUrl = await snapshot.ref.getDownloadURL();
      await _updateUserProfile(imageUrl);
    } catch (e) {
      safePrint("Error uploading image: $e");
    }
  }

  /// ✅ Update Firestore with the new image URL
  Future<void> _updateUserProfile(String imageUrl) async {
    String userId = SharedPref.getString(key: MySharedKeys.userId) ?? "";

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'photoUrl': imageUrl,
    });

    setState(() {
      _downloadUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (_imageFile != null) {
      imageProvider = FileImage(_imageFile!);
    } else if (_downloadUrl != null &&
        Uri.tryParse(_downloadUrl!)?.isAbsolute == true) {
      imageProvider = NetworkImage(_downloadUrl!);
    } else {
      imageProvider = NetworkImage(defaultPictureUrl);
    }

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        margin: EdgeInsets.all(10.sp),
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.r,
              backgroundImage: imageProvider,
              child: (_imageFile == null && _downloadUrl == null)
                  ? Text(
                "U",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
            SizedBox(width: 10),
            Text(S().addProfilePicture, style: TextStyles.font18BlackBold),
          ],
        ),
      ),
    );
  }
}
