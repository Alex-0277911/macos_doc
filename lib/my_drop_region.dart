// import 'package:flutter/material.dart';
// import 'package:super_drag_and_drop/super_drag_and_drop.dart';
//
// class MyDropRegion extends StatefulWidget {
//   final Size childSize;
//   final int columns;
//   final Function(int) updateDropPreview;
//   final Widget child;
//   final VoidCallback onDrop;
//
//   const MyDropRegion({
//     required this.childSize,
//     required this.columns,
//     required this.updateDropPreview,
//     required this.child,
//     required this.onDrop,
//     super.key,
//   });
//
//   @override
//   State<MyDropRegion> createState() => _MyDropRegionState();
// }
//
// class _MyDropRegionState extends State<MyDropRegion> {
//   int? dropIndex;
//
//   @override
//   Widget build(BuildContext context) {
//     return DropRegion(
//       formats: Formats.standardFormats,
//       onDropOver: (DropOverEvent event) {
//         _updatePreview(event.position.local);
//         return DropOperation.copy;
//       },
//       onPerformDrop: (PerformDropEvent event) async {
//         widget.onDrop();
//       },
//       child: widget.child,
//     );
//   }
//
//   void _updatePreview(Offset hoverPosition) {
//     final int row = hoverPosition.dy ~/ widget.childSize.height;
//     final int column = (hoverPosition.dx - (widget.childSize.width / 2)) ~/ widget.childSize.width;
//     int newDropIndex = (row * widget.columns) + column;
//
//     if (newDropIndex != dropIndex) {
//       dropIndex = newDropIndex;
//       widget.updateDropPreview(dropIndex!);
//     }
//   }
// }
