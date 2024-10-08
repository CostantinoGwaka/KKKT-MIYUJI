import 'package:flutter/material.dart';
import 'package:miyuji/utils/TextStyles.dart';
import 'package:miyuji/utils/my_colors.dart';
import 'package:miyuji/utils/spacer.dart';

class CardBaraza extends StatelessWidget {
  const CardBaraza({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceHeight(context) * 0.80,
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5,
            child: SizedBox(
              height: deviceHeight(context) * 0.10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      //check naviagtio
                    },
                    iconSize: 50,
                    icon: Image.asset(
                      "assets/images/connect.png",
                      color: MyColors.primaryLight,
                    ),
                  ),
                  Text(
                    "Baraza la wazee",
                    style: TextStyles.caption(context).copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primaryLight,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
