import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/shared_pref.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../data/models/profile_model.dart';
import '../manager/profile_cubit.dart';

class UserImage extends StatefulWidget {
  UserImage({super.key, required this.isChanged});
  late bool isChanged;

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? _imageFile;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('S().pick an Image'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final file = await picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context, file);
              },
              child: Text("S().camera"),
            ),
            TextButton(
              onPressed: () async {
                final file =
                    await picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context, file);
              },
              child: Text('S().gallery'),
            ),
          ],
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        widget.isChanged = true;
      });
      context.read<ProfileCubit>().saveProfile(
            ProfileModel(
              email: SharedPref.getString(key: MySharedKeys.email) ?? "",
              city: SharedPref.getString(key: MySharedKeys.city) ?? "",
              phoneNumber: SharedPref.getString(key: MySharedKeys.phone) ?? "",
              photoUrl: _imageFile!.path,
              name: SharedPref.getString(key: MySharedKeys.userName) ?? "",
              uid: SharedPref.getString(key: MySharedKeys.userId)!,
            ),
          );
    }
  }

  final pictureUrl = SharedPref.getString(key: MySharedKeys.picture) ?? "";
  final userName = SharedPref.getString(key: MySharedKeys.userName) ?? "";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.sp),
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: GestureDetector(
        onTap: _pickImage,
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.sp,
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : (pictureUrl.isNotEmpty &&
                  Uri.tryParse(pictureUrl)?.hasAbsolutePath == true
                  ? NetworkImage(pictureUrl)
                  : NetworkImage('https://img.freepik.com/free-photo/abstract-surface-textures-white-concrete-stone-wall_74190-8189.jpg')),
              child: Visibility(
                visible: pictureUrl.isEmpty && _imageFile == null,
                child: Text(
                  userName.isNotEmpty ? userName[0] : '',
                  style: TextStyles.font18BlackRegular,
                ),
              ),
            ),

            horizontalSpacing(20.w),
            Text(
              "S().addProfilePicture",
              style: TextStyles.font18BlackRegular,
            ),
          ],
        ),
      ),
    );
  }
}
