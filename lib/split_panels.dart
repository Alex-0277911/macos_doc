// import 'dart:math';
//
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:macos_doc/my_draggable_widget.dart';
// import 'package:macos_doc/types.dart';
//
// import 'my_drop_region.dart';
//
// class SplitPanels extends StatefulWidget {
//   final int columns;
//   final double itemSpacing;
//
//   const SplitPanels({
//     this.columns = 5,
//     this.itemSpacing = 4.0,
//     super.key,
//   });
//
//   @override
//   State<SplitPanels> createState() => _SplitPanelsState();
// }
//
// class _SplitPanelsState extends State<SplitPanels> {
//   final List<String> upper = [];
//   final List<String> lower = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];
//
//   ElementIndex? dragStart;
//   ElementIndex? dropPreview;
//   String? hoveringData;
//
//   void onDragStart(ElementIndex start) {
//     final String data = switch (start.$2) {
//       Panel.lower => lower[start.$1],
//       Panel.upper => upper[start.$1],
//     };
//
//     setState(() {
//       dragStart = start;
//       hoveringData = data;
//     });
//   }
//
//   void drop() {
//     assert(dropPreview != null, 'Can only drop over a know location');
//     assert(hoveringData != null, 'Can only drop when data is being dragged');
//     setState(() {
//       if (dragStart != null) {
//         if (dragStart!.$2 == Panel.upper) {
//           upper.removeAt(dragStart!.$1);
//         } else {
//           lower.removeAt(dragStart!.$1);
//         }
//
//         if (dragStart!.$2 == Panel.upper) {
//           upper.insert(min(dropPreview!.$1, upper.length), hoveringData!);
//         } else {
//           lower.insert(min(dropPreview!.$1, lower.length), hoveringData!);
//         }
//         dragStart = null;
//         dropPreview = null;
//         hoveringData = null;
//       }
//     });
//   }
//
//   void updateDropPreview(ElementIndex update) => setState(() => dropPreview = update);
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       final int gutters = widget.columns + 1;
//       final double spaseForColumns = constraints.maxWidth - (widget.itemSpacing * gutters);
//       final double columnWidth = spaseForColumns / widget.columns;
//       final Size itemSize = Size(columnWidth, columnWidth);
//       return Stack(
//         children: [
//           Positioned(
//             height: constraints.maxHeight / 2,
//             width: constraints.maxWidth,
//             top: 0.0,
//             child: MyDropRegion(
//               onDrop: drop,
//               updateDropPreview: updateDropPreview,
//               columns: widget.columns,
//               childSize: itemSize,
//               panel: Panel.upper,
//               child: ItemPanel(
//                 dropPreview: dropPreview?.$2 == Panel.upper ? dropPreview : null,
//                 hoveringData: dropPreview?.$2 == Panel.upper ? hoveringData : null,
//                 dragStart: dragStart?.$2 == Panel.upper ? dragStart : null,
//                 onDragStart: onDragStart,
//                 panel: Panel.upper,
//                 items: upper,
//                 crossAxisCount: widget.columns,
//                 spacing: widget.itemSpacing,
//               ),
//             ),
//           ),
//           Positioned(
//             height: 2.0,
//             width: constraints.maxWidth,
//             top: constraints.maxHeight / 2,
//             child: ColoredBox(color: Colors.black),
//           ),
//           Positioned(
//             height: constraints.maxHeight / 2,
//             width: constraints.maxWidth,
//             bottom: 0.0,
//             child: MyDropRegion(
//               onDrop: drop,
//               updateDropPreview: updateDropPreview,
//               columns: widget.columns,
//               childSize: itemSize,
//               panel: Panel.lower,
//               child: ItemPanel(
//                 dropPreview: dropPreview?.$2 == Panel.lower ? dropPreview : null,
//                 hoveringData: dropPreview?.$2 == Panel.lower ? hoveringData : null,
//                 dragStart: dragStart?.$2 == Panel.lower ? dragStart : null,
//                 onDragStart: onDragStart,
//                 items: lower,
//                 panel: Panel.lower,
//                 crossAxisCount: widget.columns,
//                 spacing: widget.itemSpacing,
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
//
// class ItemPanel extends StatelessWidget {
//   final int crossAxisCount;
//   final List<String> items;
//   final double spacing;
//   final Function(ElementIndex) onDragStart;
//   final Panel panel;
//   final ElementIndex? dragStart;
//   final ElementIndex? dropPreview;
//   final String? hoveringData;
//
//   const ItemPanel({
//     required this.crossAxisCount,
//     required this.items,
//     required this.spacing,
//     required this.onDragStart,
//     required this.panel,
//     required this.dragStart,
//     required this.dropPreview,
//     required this.hoveringData,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> itemsCopy = List<String>.from(items);
//
//     ElementIndex? dragStartCopy;
//     ElementIndex? dropPreviewCopy;
//     if (dragStart != null) {
//       dragStartCopy = dragStart!.copyWith();
//     }
//
//     if (dropPreview != null && hoveringData != null) {
//       dropPreviewCopy = dropPreview!.copyWith(
//         index: min(items.length, dropPreview!.$1),
//       );
//
//       if (dragStartCopy?.$2 == dropPreviewCopy.$2) {
//         itemsCopy.removeAt(dragStartCopy!.$1);
//         dragStartCopy = null;
//       }
//       itemsCopy.insert(
//         min(dropPreview!.$1, itemsCopy.length),
//         hoveringData!,
//       );
//     }
//     return GridView.count(
//       crossAxisCount: crossAxisCount,
//       padding: EdgeInsets.all(4.0),
//       mainAxisSpacing: spacing,
//       crossAxisSpacing: spacing,
//       children: itemsCopy.asMap().entries.map<Widget>(
//         (MapEntry<int, String> entry) {
//           Color textColor =
//               entry.key == dragStartCopy?.$1 || entry.key == dropPreviewCopy?.$1 ? Colors.grey : Colors.white;
//           Widget child = Center(
//             child: Text(
//               entry.value,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 36.0, color: textColor),
//             ),
//           );
//
//           if (entry.key == dragStartCopy?.$1) {
//             child = Container(
//               height: 200.0,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
//               ),
//               child: child,
//             );
//           } else if (entry.key == dropPreviewCopy?.$1) {
//             child = DottedBorder(
//               borderType: BorderType.RRect,
//               radius: Radius.circular(20.0),
//               dashPattern: [10.0, 10.0],
//               color: Colors.grey,
//               strokeWidth: 2.0,
//               child: child,
//             );
//           } else {
//             child = Container(
//               height: 200.0,
//               decoration: BoxDecoration(
//                 color: Colors.grey,
//                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
//               ),
//               child: child,
//             );
//           }
//           return Draggable(
//             feedback: child,
//             child: MyDraggableWidget(
//               data: entry.value,
//               onDragStart: () => onDragStart((entry.key, panel)),
//               child: child,
//             ),
//           );
//         },
//       ).toList(),
//     );
//   }
// }
