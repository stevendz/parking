import 'package:flutter/material.dart';
import 'package:parking/widgets/primary_button.dart';

class SocialAuthentication extends StatelessWidget {
  const SocialAuthentication({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Divider(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'or continue with',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: PrimaryButton(
                text: 'Google',
                onClick: () {},
                color: Colors.indigo,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: PrimaryButton(
                text: 'Facebook',
                onClick: () {},
                color: Colors.blue.shade400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
