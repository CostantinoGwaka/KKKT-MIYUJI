import 'package:miyuji/akaunti/screens/constant.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileListItem extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final bool hasNavigation;

  const ProfileListItem({
    super.key,
    this.icon,
    this.text,
    this.hasNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ).copyWith(
        bottom: 20,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey.shade300,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 25,
          ),
          const SizedBox(width: 15),
          Text(
            text.toString(),
            style: kTitleTextStyle.copyWith(fontWeight: FontWeight.w500, fontFamily: "Poppins"),
          ),
          const Spacer(),
          if (hasNavigation)
            const Icon(
              LineAwesomeIcons.arrow_right_solid,
              size: 25,
            ),
        ],
      ),
    );
  }
}
