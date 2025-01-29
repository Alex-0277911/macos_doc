// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
//
// import 'grid_item_widget.dart';
// import 'images.dart';
//
// class GridExample extends StatefulWidget {
//   const GridExample({super.key, required this.title});
//
//   final String title;
//
//   @override
//   GridExampleState createState() => GridExampleState();
// }
//
// class GridExampleState extends State<GridExample> {
//   final List<DraggableGridItem> _listOfDraggableGridItem = [];
//
//   @override
//   void initState() {
//     _generateImageData();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           widget.title,
//         ),
//       ),
//       floatingActionButton: ElevatedButton(
//         onPressed: () {
//           setState(() {
//             if (_listOfDraggableGridItem.length > 1) {
//               _listOfDraggableGridItem.removeAt(0);
//             } else {
//               log('Children must not be empty.');
//             }
//           });
//         },
//         child: const Icon(
//           Icons.delete,
//           size: 24,
//         ),
//       ),
//       body: SafeArea(
//         child: DraggableGridViewBuilder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3),
//           ),
//           children: _listOfDraggableGridItem,
//           dragCompletion: onDragAccept,
//           dragStarted: () {
//             log('dragStarted...');
//           },
//           isOnlyLongPress: true,
//           dragFeedback: feedback,
//           dragPlaceHolder: placeHolder,
//         ),
//       ),
//     );
//   }
//
//   Widget feedback(List<DraggableGridItem> list, int index) {
//     return SizedBox(
//       width: 200,
//       height: 150,
//       child: list[index].child,
//     );
//   }
//
//   PlaceHolderWidget placeHolder(List<DraggableGridItem> list, int index) {
//     return PlaceHolderWidget(
//       child: Container(
//         color: Colors.white,
//       ),
//     );
//   }
//
//   void onDragAccept(List<DraggableGridItem> list, int beforeIndex, int afterIndex) {
//     log('onDragAccept: $beforeIndex -> $afterIndex');
//     setState(() {
//       _listOfDraggableGridItem.clear();
//       _listOfDraggableGridItem.addAll(list);
//     });
//   }
//
//   void _generateImageData() {
//     _listOfDraggableGridItem.addAll(
//       [
//         DraggableGridItem(
//           child: const GridItem(icon: Images.asset_1),
//           isDraggable: true,
//           dragCallback: (context, isDragging) {
//             log('isDragging: $isDragging');
//           },
//         ),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_2), isDraggable: true),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_3), isDraggable: true),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_4), isDraggable: true),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_5), isDraggable: false),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_6), isDraggable: true),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_7), isDraggable: true),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_8), isDraggable: true),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_9), isDraggable: true),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_10), isDraggable: true),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_11), isDraggable: true),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_12), isDraggable: true),
//         DraggableGridItem(child: const GridItem(icon: Images.asset_13), isDraggable: true),
//       ],
//     );
//   }
// }
