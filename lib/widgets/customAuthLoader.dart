import 'package:fairstores/constants.dart';
import 'package:flutter/material.dart';

class CustomAuthLoader extends StatelessWidget {

  CustomAuthLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: CircularProgressIndicator(
              color: kPrimary,
            ),
          ),
        ],
      )
    );
  }
}
