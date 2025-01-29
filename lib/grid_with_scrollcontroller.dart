// import 'package:flutter/material.dart';
// import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:macos_doc/core/providers/riverpod_providers.dart';
//
// import 'grid_item_widget.dart';
//
// class GridWithScrollController extends ConsumerStatefulWidget {
//   const GridWithScrollController({
//     super.key,
//   });
//
//   @override
//   GridWithScrollControllerState createState() => GridWithScrollControllerState();
// }
//
// class GridWithScrollControllerState extends ConsumerState<GridWithScrollController> {
//   ///
//   List<DraggableGridItem> _listOfDraggableGridItem = [];
//   // final ScrollController _scrollController = ScrollController(
//   //   initialScrollOffset: 0.0,
//   //   keepScrollOffset: true,
//   // );
//
//   static const List<IconData> iconDataList = [
//     Icons.person,
//     Icons.message,
//     Icons.call,
//     Icons.camera,
//     Icons.photo,
//   ];
//
//   List<int> _listIndexes = [];
//
//   void _generateIconData() {
//     ///
//     // _listOfDraggableGridItem.addAll(
//     //   List.generate(iconDataList.length, (int index) {
//     //     return DraggableGridItem(
//     //       child: GridItem(
//     //         index: index,
//     //         icon: iconDataList[index],
//     //       ),
//     //       isDraggable: true,
//     //       dragCallback: (context, isDragging) {
//     //         // log('isDragging: $isDragging');
//     //         ref.read(draggingElementProvider.notifier).update(isDragging);
//     //       },
//     //     );
//     //   }),
//     // );
//     final List<DraggableGridItem> listItems = List.generate(iconDataList.length, (int index) {
//       return DraggableGridItem(
//         child: GridItem(
//           index: index,
//           icon: iconDataList[index],
//         ),
//         isDraggable: true,
//         dragCallback: (context, isDragging) {
//           // log('isDragging: $isDragging');
//           ref.read(draggingElementProvider.notifier).update(isDragging, index);
//           // ref.read(indexDraggingElementProvider.notifier).update(index);
//         },
//       );
//     });
//     ref.read(listOfDraggableGridItemProvider.notifier).update(listItems);
//   }
//
//   void onDragAccept(List<DraggableGridItem> list, int beforeIndex, int afterIndex) {
//     // log('onDragAccept: $beforeIndex -> $afterIndex');
//     ref.read(draggingElementProvider.notifier).update(false, -1);
//     // ref.read(indexDraggingElementProvider.notifier).update(-1);
//
//     ///
//     final int temp = _listIndexes[beforeIndex];
//     _listIndexes.removeAt(beforeIndex);
//     _listIndexes.insert(afterIndex, temp);
//     ref.read(indexesItemsProvider.notifier).update(_listIndexes);
//
//     // setState(() {
//     //   _listOfDraggableGridItem.clear();
//     //   _listOfDraggableGridItem.addAll(list);
//     // });
//     ref.read(listOfDraggableGridItemProvider.notifier)
//       ..clear()
//       ..update(list);
//   }
//
//   // void onDragOutOfZone() {
//   //   print('onDragOutOfZone');
//   //   final int deleteElementIndex = ref.watch(draggingElementProvider).$2;
//   //   print('deleteElementIndex => $deleteElementIndex');
//   //   // if (deleteElementIndex != -1) {
//   //   // final List<DraggableGridItem> listElements = ref.read(listOfDraggableGridItemProvider);
//   //   // listElements.removeAt(deleteElementIndex);
//   //   // ref.read(listOfDraggableGridItemProvider.notifier).update(listElements);
//   //   // }              onDragOutOfZone();
//   //   // setState(() {
//   //   //   // _listOfDraggableGridItem.clear();
//   //   //   // _listOfDraggableGridItem.addAll(list);
//   //   // });
//   // }
//
//   @override
//   void initState() {
//     // _generateIconData();
//     // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//     //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//     // });
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _generateIconData();
//       final List<int> indexes = List.generate(iconDataList.length, (i) => i);
//       ref.read(indexesItemsProvider.notifier).update(indexes);
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     _listIndexes = List.from(ref.watch(indexesItemsProvider));
//     _listOfDraggableGridItem = List.from(ref.watch(listOfDraggableGridItemProvider));
//     return _listOfDraggableGridItem.isNotEmpty
//         ? MouseRegion(
//             onEnter: ((event) {
//               ref.read(outsideZoneProvider.notifier).update(false);
//
//               // /// load save data
//               // final List<DraggableGridItem> listSavedData = List.from(ref.read(savedDraggableGridItemProvider));
//               //
//               // /// delete element and update active list
//               // if (listSavedData.isNotEmpty) {
//               //   ref.read(listOfDraggableGridItemProvider.notifier)
//               //     ..clear()
//               //     ..update(listSavedData);
//               // }
//             }),
//             onExit: (event) {
//               ref.read(outsideZoneProvider.notifier).update(true);
//               ref.read(hoveredIndexProvider.notifier).update(-2);
//
//               // ///
//               // final int indexDeletedItem = ref.read(draggingElementProvider).$2;
//               // final List<DraggableGridItem> activeListData = ref.read(listOfDraggableGridItemProvider);
//               //
//               // if (indexDeletedItem == -1) {
//               //   return;
//               // }
//               //
//               // /// save active list
//               // ref.read(savedDraggableGridItemProvider.notifier)
//               //   ..clear()
//               //   ..update(activeListData);
//               //
//               // /// delete element and update active list
//               // activeListData.removeAt(indexDeletedItem);
//               // ref.read(listOfDraggableGridItemProvider.notifier)
//               //   ..clear()
//               //   ..update(activeListData);
//             },
//             child: Container(
//               constraints: BoxConstraints(maxHeight: 70.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 color: Colors.black12,
//               ),
//               padding: const EdgeInsets.all(4.0),
//               child: DraggableGridViewBuilder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 scrollDirection: Axis.horizontal,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 1,
//                 ),
//                 children: _listOfDraggableGridItem,
//                 dragCompletion: onDragAccept,
//                 dragStarted: () {},
//                 isOnlyLongPress: false,
//                 dragFeedback: feedback,
//                 dragPlaceHolder: placeHolder,
//               ),
//             ),
//           )
//         : SizedBox.shrink();
//   }
//
//   Widget feedback(List<DraggableGridItem> list, int index) {
//     return Material(
//       color: Colors.transparent,
//       child: Opacity(
//         opacity: 0.6,
//         child: _listOfDraggableGridItem[index].child,
//       ),
//     );
//   }
//
//   PlaceHolderWidget placeHolder(List<DraggableGridItem> list, int index) {
//     return PlaceHolderWidget(
//       child: Consumer(builder: (context, ref, child) {
//         final bool isOutsideZone = ref.watch(outsideZoneProvider);
//         return AnimatedContainer(
//           constraints: BoxConstraints(maxWidth: 30.0, maxHeight: 30.0),
//           width: 20.0,
//           height: 20.0,
//           alignment: Alignment.center,
//           duration: const Duration(milliseconds: 200),
//           color: isOutsideZone ? Colors.red : Colors.blue,
//         );
//       }),
//     );
//   }
// }
