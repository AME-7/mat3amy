import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TextShimmer extends StatelessWidget {
  const TextShimmer({
    super.key,
    this.height = 20,
    this.width = double.infinity,
  });
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
      ),
    );
  }
}
