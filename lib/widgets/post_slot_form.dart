import 'package:flutter/material.dart';

class PostSlotForm extends StatelessWidget {
  const PostSlotForm({
    Key key,
    @required this.titleController,
    @required this.descriptionController,
    @required this.hourlyController,
    @required this.dailyController,
  }) : super(key: key);

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController hourlyController;
  final TextEditingController dailyController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(helperText: 'Title'),
        ),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(helperText: 'Description'),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: dailyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: 'Daily',
                  suffixIcon: Icon(Icons.attach_money),
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: TextFormField(
                controller: hourlyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: 'Hourly',
                  suffixIcon: Icon(Icons.attach_money),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
