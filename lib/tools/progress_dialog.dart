import 'package:flutter/material.dart';

import 'file:///C:/Users/elisvobs/FlutterProjects/gugulethu/lib/views/shared/app_colors.dart';
import 'file:///C:/Users/elisvobs/FlutterProjects/gugulethu/lib/views/shared/styles.dart';

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: black.withAlpha(200),
      child: Center(
        child: new Container(
          padding: const EdgeInsets.all(30.0),
          child: new GestureDetector(
            onTap: () => Navigator.pop(context),
            child: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new SizedBox(height: 15.0),
                  new Text("Please wait.....", style: texts),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
