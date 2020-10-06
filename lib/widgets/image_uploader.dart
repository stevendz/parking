import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader extends StatelessWidget {
  const ImageUploader({
    Key key,
    @required this.image,
    @required this.uploadImage,
    @required this.selectImageReminder,
  }) : super(key: key);

  final Function uploadImage;
  final String image;
  final bool selectImageReminder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: upload,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: selectImageReminder ? Colors.red : Colors.grey,
          ),
        ),
        child: image == null
            ? Icon(
                Icons.add_a_photo,
                color: selectImageReminder ? Colors.red : Colors.grey,
              )
            : Image.network(
                image,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Future<void> upload() async {
    PickedFile pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      uploadImage(pickedImage);
    }
  }
}
