import 'package:flutter/material.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class ActivityBarWidget extends StatelessWidget {
  const ActivityBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: kBgCardLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 0,
          decoration: BoxDecoration(
            color: kAccentPrimary,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
