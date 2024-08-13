// Import the image_picker plugin
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:step/app/core/constants_and_enums/static_data.dart';
import 'package:step/app/core/extensions_and_so_on/extesions.dart';
import 'package:step/app/core/themes/colors.dart';

import '../core/data/models/logged_user.dart';
import '../utils/helper_funcs.dart';
import 'messages.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({
    super.key,
    required this.loggedUser,
  });

  final LoggedUser loggedUser;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _imageFile;

  // This is the image picker
  final _picker = ImagePicker();

  // This method will show a dialog to let the user choose between gallery or camera
  Future<void> _showImageSourceDialog() async {
    // Create a list of selection items
    final items = [
      SelectionItem(
        text: 'Gallery',
        action: () {
          // Close the dialog and pick an image from the gallery
          Navigator.pop(context);
          _pickImage(ImageSource.gallery);
        },
      ),
      // SelectionItem(
      //   text: 'Camera',
      //   action: () {
      //     // Close the dialog and pick an image from the camera
      //     Navigator.pop(context);
      //     _pickImage(ImageSource.camera);
      //   },
      // ),
    ];

    // Show the dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select an image source',
          style: TextStyle(color: kPrimaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) => _getOptionWidget(item)).toList(),
        ),
      ),
    );
  }

  // This method will pick an image from the given source
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        uploadImage();
      });
    }
  }

  // This method will create a widget for each selection item
  Widget _getOptionWidget(SelectionItem item) {
    return SimpleDialogOption(
      onPressed: item.action,
      child: Text(
        item.text,
        style: TextStyle(
          color: getThemeData(context).colorScheme.onBackground,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  uploadImage() async {
    MultipartFile multipartFile =
        await MultipartFile.fromFile(_imageFile!.path);
    var data = FormData.fromMap({
      'image': multipartFile,
    });

    var dio = Dio();
    var response = await dio.request(
      '${StaticData.baseUrl}/signleteacher/apis.php?function=upload_image&token=${widget.loggedUser.token}',
      options: Options(
        method: 'POST',
      ),
      data: data,
    );

    if (response.statusCode == 200 && response.data['status'] == "success") {
      showSnackBar(context, getL10(context).updatedSuccesfull,
          color: Colors.greenAccent);
    } else {
      showSnackBar(context, getL10(context).sorryProlemFromUs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: _imageFile == null
                ? DecorationImage(
                    image: NetworkImage(
                      widget.loggedUser.image,
                    ),
                    fit: BoxFit.fill,
                  )
                : DecorationImage(
                    image: FileImage(
                      _imageFile!,
                    ),
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          // width: 70,
          // height: 20,
          child: Container(
            decoration: BoxDecoration(
              color: kOnPrimary.withOpacity(0.95),
              // borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
            ),
          ),
        ),
      ],
    ).onTap(_showImageSourceDialog);
  }
}

// This class represents a selection item for the image source dialog
class SelectionItem {
  final String text;
  final GestureTapCallback action;

  SelectionItem({required this.text, required this.action});
}
