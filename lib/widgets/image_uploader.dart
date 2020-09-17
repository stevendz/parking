import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader extends StatelessWidget {
  final Function uploadImage;
  const ImageUploader({
    Key key,
    @required this.slotImage,
    @required this.uploadImage,
  }) : super(key: key);

  final String slotImage;

  upload() async {
    PickedFile pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    uploadImage(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: upload,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: slotImage == null
            ? Icon(
                Icons.add_a_photo,
                color: Colors.grey,
              )
            : Image.network(
                slotImage,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
