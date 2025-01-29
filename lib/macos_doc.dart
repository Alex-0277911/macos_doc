// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:macos_doc/my_draggable_widget.dart';
//
// import 'my_drop_region.dart';
//
// class MacOsDoc extends StatefulWidget {
//   final int columns;
//   final double itemSpacing;
//
//   const MacOsDoc({
//     this.columns = 5,
//     this.itemSpacing = 10.0,
//     super.key,
//   });
//
//   @override
//   State<MacOsDoc> createState() => _MacOsDocState();
// }
//
// class _MacOsDocState extends State<MacOsDoc> {
//   final List<String> iconDataList = ['A', 'B', 'C', 'D', 'E'];
//
//   int? dragStart;
//   int? dropPreview;
//   String? hoveringData;
//
//   void onDragStart(int start) {
//     // final String data = switch (start.$2) {
//     //   Panel.lower => iconDataList[start.$1],
//     //   Panel.upper => upper[start.$1],
//     // };
//     setState(() {
//       dragStart = start;
//       hoveringData = iconDataList[start];
//       // hoveringData = data;
//     });
//   }
//
//   void drop() {
//     assert(dropPreview != null, 'Can only drop over a know location');
//     assert(hoveringData != null, 'Can only drop when data is being dragged');
//     setState(() {
//       if (dragStart != null) {
//         // iconDataList.removeAt(dragStart!);
//         // iconDataList.insert(min(dropPreview!, iconDataList.length), hoveringData!);
//         // if (dragStart!.$2 == Panel.upper) {
//         //   // upper.removeAt(dragStart!.$1);
//         // } else {
//         //   iconDataList.removeAt(dragStart!.$1);
//         // }
//
//         // if (dragStart!.$2 == Panel.upper) {
//         //   // upper.insert(min(dropPreview!.$1, upper.length), hoveringData!);
//         // } else {
//         //   iconDataList.insert(min(dropPreview!.$1, iconDataList.length), hoveringData!);
//         // }
//         // dragStart = null;
//         // dropPreview = null;
//         // hoveringData = null;
//       }
//     });
//   }
//
//   void updateDropPreview(int update) => setState(() => dropPreview = update);
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       final int gutters = widget.columns + 1;
//       // final double spaseForColumns = constraints.maxWidth - (widget.itemSpacing * gutters);
//       final double spaseForColumns = (widget.columns * 50) + (widget.itemSpacing * gutters);
//       final double columnWidth = spaseForColumns / widget.columns;
//       final Size itemSize = Size(columnWidth, columnWidth);
//       return Stack(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             height: double.infinity,
//           ),
//           // Positioned(
//           //   height: constraints.maxHeight / 2,
//           //   width: constraints.maxWidth,
//           //   top: 0.0,
//           //   child: MyDropRegion(
//           //     onDrop: drop,
//           //     updateDropPreview: updateDropPreview,
//           //     columns: widget.columns,
//           //     childSize: itemSize,
//           //     panel: Panel.upper,
//           //     child: ItemPanel(
//           //       dropPreview: dropPreview?.$2 == Panel.upper ? dropPreview : null,
//           //       hoveringData: dropPreview?.$2 == Panel.upper ? hoveringData : null,
//           //       dragStart: dragStart?.$2 == Panel.upper ? dragStart : null,
//           //       onDragStart: onDragStart,
//           //       panel: Panel.upper,
//           //       items: upper,
//           //       crossAxisCount: widget.columns,
//           //       spacing: widget.itemSpacing,
//           //     ),
//           //   ),
//           // ),
//           // Positioned(
//           //   height: 2.0,
//           //   width: constraints.maxWidth,
//           //   top: constraints.maxHeight / 2,
//           //   child: ColoredBox(color: Colors.black),
//           // ),
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 color: Colors.black12,
//               ),
//               padding: const EdgeInsets.all(4.0),
//               height: itemSize.height + 8.0,
//               width: spaseForColumns,
//               child: MyDropRegion(
//                 onDrop: drop,
//                 updateDropPreview: updateDropPreview,
//                 columns: widget.columns,
//                 childSize: itemSize,
//                 child: ItemPanel(
//                   dropPreview: dropPreview,
//                   hoveringData: dropPreview != null ? hoveringData : null,
//                   dragStart: dragStart,
//                   onDragStart: onDragStart,
//                   items: iconDataList,
//                   crossAxisCount: widget.columns,
//                   spacing: widget.itemSpacing,
//                 ),
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
//   final Function(int) onDragStart;
//   final int? dragStart;
//   final int? dropPreview;
//   final String? hoveringData;
//
//   const ItemPanel({
//     required this.crossAxisCount,
//     required this.items,
//     required this.spacing,
//     required this.onDragStart,
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
//     int? dragStartCopy;
//     int? dropPreviewCopy;
//     if (dragStart != null) {
//       dragStartCopy = dragStart;
//     }
//
//     if (dropPreview != null && hoveringData != null) {
//       dropPreviewCopy = min(items.length, dropPreview!);
//
//       if (dragStartCopy == dropPreviewCopy) {
//         itemsCopy.removeAt(dragStartCopy!);
//         dragStartCopy = null;
//       }
//       itemsCopy.insert(
//         min(dropPreview!, itemsCopy.length),
//         hoveringData!,
//       );
//     }
//     return Row(
//       // crossAxisCount: crossAxisCount,
//       // padding: EdgeInsets.all(4.0),
//       // mainAxisSpacing: spacing,
//       // crossAxisSpacing: spacing,
//       children: itemsCopy.asMap().entries.map<Widget>(
//         (MapEntry<int, String> entry) {
//           Color textColor = entry.key == dragStartCopy || entry.key == dropPreviewCopy ? Colors.grey : Colors.white;
//           Widget child = Center(
//             child: Text(
//               entry.value,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 36.0, color: textColor),
//             ),
//           );
//
//           if (entry.key == dragStartCopy) {
//             // child = Container(
//             //   decoration: BoxDecoration(
//             //     color: Colors.red,
//             //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//             //   ),
//             //   child: child,
//             // );
//           } else if (entry.key == dropPreviewCopy) {
//             /// місце вставки віджета
//             // child = Container(
//             //   decoration: BoxDecoration(
//             //     color: Colors.transparent,
//             //     borderRadius: BorderRadius.all(Radius.circular(8.0)),
//             //   ),
//             //   // child: child,
//             // );
//           } else {
//             child = Container(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.all(Radius.circular(8.0)),
//               ),
//               child: child,
//             );
//           }
//           return Draggable(
//             feedback: child,
//             child: MyDraggableWidget(
//               data: entry.value,
//               onDragStart: () => onDragStart(entry.key),
//               child: child,
//             ),
//           );
//         },
//       ).toList(),
//     );
//   }
// }
