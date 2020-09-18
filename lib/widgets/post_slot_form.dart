import 'package:flutter/material.dart';

class PostSlotForm extends StatelessWidget {
  const PostSlotForm({
    Key key,
    @required this.titleController,
    @required this.descriptionController,
    @required this.hourlyController,
    @required this.dailyController,
    @required this.formKey,
  }) : super(key: key);

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController hourlyController;
  final TextEditingController dailyController;
  final GlobalKey formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: titleController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter daily price';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter hourly price';
                    }
                    return null;
                  },
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
      ),
    );
  }
}
