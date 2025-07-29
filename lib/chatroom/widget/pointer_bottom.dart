import 'package:flutter/material.dart';
import 'package:kanisaapp/utils/spacer.dart';

class PointerBottom extends StatelessWidget {
  const PointerBottom({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: deviceHeight(context) / 10,
      right: 10,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(deviceHeight(context) / 30),
          ),
        ),
        child: CircleAvatar(
          radius: deviceHeight(context) / 40,
          backgroundColor: Colors.green[100],
          child: IconButton(
            onPressed: () {
              // _animate(
              //   time: 400,
              // );
            },
            icon: const Icon(Icons.arrow_circle_down),
          ),
        ),
      ),
    );
  }
}
