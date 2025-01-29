import 'package:flutter/material.dart';

class AnimatedItem extends StatelessWidget {
  final double sizeAnim;
  final IconData item;

  const AnimatedItem({
    required this.sizeAnim,
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      alignment: Alignment.bottomCenter,
      duration: const Duration(milliseconds: 200),
      scale: sizeAnim,
      child: Container(
        constraints: BoxConstraints(minWidth: 48.0),
        height: 48.0,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.primaries[item.hashCode % Colors.primaries.length],
        ),
        child: Center(child: Icon(item, color: Colors.white)),
      ),
    );
  }
}
