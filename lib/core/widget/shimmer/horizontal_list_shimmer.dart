import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalListShimmer extends StatelessWidget {
  const HorizontalListShimmer({
    super.key,
    this.itemCount = 5,
    this.height = 150,
    this.width = 120,
    this.spacing = 10,
  });

  final int itemCount;
  final double height;
  final double width;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (context, index) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
