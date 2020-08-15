import 'package:flutter/material.dart';

class LoadingUsers extends StatelessWidget {
  const LoadingUsers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
