// import 'package:flutter/material.dart';
// import 'package:macos_doc/animated_item.dart';
// import 'package:macos_doc/main.dart';
//
// class AnimatedDoc extends StatefulWidget {
//   const AnimatedDoc({
//     super.key,
//   });
//
//   @override
//   State<AnimatedDoc> createState() => _AnimatedDocState();
// }
//
// class _AnimatedDocState extends State<AnimatedDoc> {
//   static const List<IconData> iconDataList = [
//     Icons.person,
//     Icons.message,
//     Icons.call,
//     Icons.camera,
//     Icons.photo,
//   ];
//
//   final List<double> listSizeAnimation = List.generate(
//     iconDataList.length,
//     (index) => 1.0,
//   );
//
//   double animEmptyContainer = 1.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Dock(
//       items: iconDataList,
//       builder: (item) {
//         final int index = iconDataList.indexOf(item);
//         return MouseRegion(
//           onEnter: ((event) {
//             if (index - 1 >= 0) {
//               listSizeAnimation[index - 1] = 1.1;
//             }
//             if (index + 1 < iconDataList.length) {
//               listSizeAnimation[index + 1] = 1.1;
//             }
//             setState(() {
//               listSizeAnimation[index] = 1.2;
//             });
//           }),
//           onExit: (event) {
//             for (int index = 0; index < listSizeAnimation.length; index++) {
//               listSizeAnimation[index] = 1.0;
//             }
//             setState(() {});
//           },
//           child: Draggable(
//             feedback: AnimatedItem(
//               sizeAnim: listSizeAnimation[index],
//               item: item,
//             ),
//             onDragStarted: () {
//               print(animEmptyContainer);
//               animEmptyContainer = 0.5;
//               setState(() {});
//               print(animEmptyContainer);
//             },
//             childWhenDragging: AnimatedScale(
//               alignment: Alignment.bottomCenter,
//               duration: const Duration(milliseconds: 2000),
//               scale: animEmptyContainer,
//               child: Container(
//                 constraints: BoxConstraints(minWidth: 64.0),
//                 height: 64.0,
//                 color: Colors.red,
//               ),
//             ),
//             child: AnimatedItem(
//               sizeAnim: listSizeAnimation[index],
//               item: item,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
