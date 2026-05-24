import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_collar_app/core/constants/colors.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key, this.height = 16, this.width});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: kBgCard,
      highlightColor: kBgCardLight,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: kBgCard,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
