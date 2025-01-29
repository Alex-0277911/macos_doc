// import 'package:flutter/material.dart';
// import 'package:super_drag_and_drop/super_drag_and_drop.dart';
//
// class MyDraggableWidget extends StatelessWidget {
//   final String data;
//   final Widget child;
//   final Function() onDragStart;
//
//   const MyDraggableWidget({
//     required this.data,
//     required this.child,
//     required this.onDragStart,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return DragItemWidget(
//       dragItemProvider: (DragItemRequest request) {
//         onDragStart();
//         final DragItem item = DragItem(
//           localData: data,
//         );
//         return item;
//       },
//       dragBuilder: (context, child) {
//         return Opacity(
//           opacity: 0.8,
//           child: child,
//         );
//       },
//       allowedOperations: () => [DropOperation.copy],
//       child: DraggableWidget(child: child),
//     );
//   }
// }
