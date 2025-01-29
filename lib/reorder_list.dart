// import 'package:flutter/material.dart';
//
// class DraggableListExample extends StatefulWidget {
//   const DraggableListExample({super.key});
//
//   @override
//   State<DraggableListExample> createState() => _DraggableListExampleState();
// }
//
// class _DraggableListExampleState extends State<DraggableListExample> {
//   static const List<IconData> iconDataList = [
//     Icons.person,
//     Icons.message,
//     Icons.call,
//     Icons.camera,
//     Icons.photo,
//   ];
//
//   int? draggingIndex;
//   int? hoverIndex;
//
//   void _onDragStarted(int index) {
//     setState(() {
//       draggingIndex = index;
//     });
//   }
//
//   void _onDragEnded() {
//     setState(() {
//       draggingIndex = null;
//       hoverIndex = null;
//     });
//   }
//
//   void _onDragHover(int index) {
//     setState(() {
//       hoverIndex = index;
//     });
//   }
//
//   void _insertDraggedItem(int index) {
//     if (draggingIndex != null) {
//       setState(() {
//         final IconData iconData = iconDataList.removeAt(draggingIndex!);
//
//         iconDataList.insert(index, iconData);
//         draggingIndex = null;
//         hoverIndex = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ...List.generate(iconDataList.length, (index) {
//               final bool isHovered = hoverIndex == index && draggingIndex != null;
//               return DragTarget<int>(
//                 onWillAcceptWithDetails: (draggedIndex) {
//                   if (draggedIndex != draggingIndex) {
//                     _onDragHover(index);
//                   }
//                   return true;
//                 },
//                 onLeave: (data) {
//                   setState(() {
//                     hoverIndex = null;
//                   });
//                 },
//                 onAcceptWithDetails: (draggedIndex) {
//                   _insertDraggedItem(index);
//                 },
//                 builder: (context, candidateData, rejectedData) {
//                   return AnimatedContainer(
//                     duration: Duration(milliseconds: 300),
//                     curve: Curves.easeInOut,
//                     margin: isHovered ? EdgeInsets.symmetric(horizontal: 50.0) : EdgeInsets.zero,
//                     child: draggingIndex == index
//                         ? SizedBox(width: 0.0, height: 0.0)
//                         : Draggable<int>(
//                             data: index,
//                             onDragStarted: () => _onDragStarted(index),
//                             onDragEnd: (details) => _onDragEnded(),
//                             feedback: Material(
//                               color: Colors.transparent,
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 width: 50.0,
//                                 height: 50.0,
//                                 color: Colors.primaries[index],
//                                 child: Text('$index'),
//                               ),
//                             ),
//                             childWhenDragging: Container(
//                               alignment: Alignment.center,
//                               width: 50.0,
//                               height: 50.0,
//                               color: Colors.primaries[index],
//                               child: Text('$index'),
//                             ),
//                             child: Container(
//                               alignment: Alignment.center,
//                               width: 50.0,
//                               height: 50.0,
//                               color: Colors.primaries[index],
//                               child: Text('$index'),
//                             ),
//                           ),
//                   );
//                 },
//               );
//             }),
//             // ...colors.asMap().entries.map((entry) {
//             //   final int index = entry.key;
//             //   final Color color = entry.value;
//             //
//             //   // Порожнє місце для розсування
//             //   final bool isHovered = hoverIndex == index && draggingIndex != null;
//             //
//             //   return DragTarget<int>(
//             //     onWillAcceptWithDetails: (draggedIndex) {
//             //       if (draggedIndex != draggingIndex) {
//             //         _onDragHover(index);
//             //       }
//             //       return true;
//             //     },
//             //     onLeave: (data) {
//             //       setState(() {
//             //         hoverIndex = null;
//             //       });
//             //     },
//             //     onAcceptWithDetails: (draggedIndex) {
//             //       _insertDraggedItem(index);
//             //     },
//             //     builder: (context, candidateData, rejectedData) {
//             //       return AnimatedContainer(
//             //         duration: Duration(milliseconds: 300),
//             //         curve: Curves.easeInOut,
//             //         margin: isHovered ? EdgeInsets.symmetric(horizontal: 15.0) : EdgeInsets.zero,
//             //         child: draggingIndex == index
//             //             ? SizedBox(width: 50.0, height: 50.0)
//             //             : Draggable<int>(
//             //                 data: index,
//             //                 onDragStarted: () => _onDragStarted(index),
//             //                 onDragEnd: (details) => _onDragEnded(),
//             //                 feedback: Material(
//             //                   color: Colors.transparent,
//             //                   child: Container(
//             //                     width: 50.0,
//             //                     height: 50.0,
//             //                     color: color.withOpacity(0.8),
//             //                   ),
//             //                 ),
//             //                 childWhenDragging: Container(
//             //                   width: 50.0,
//             //                   height: 50.0,
//             //                   color: Colors.grey,
//             //                 ),
//             //                 child: Container(
//             //                   width: 50.0,
//             //                   height: 50.0,
//             //                   color: color,
//             //                 ),
//             //               ),
//             //       );
//             //     },
//             //   );
//             // }).toList(),
//
//             // Місце для розташування елемента після списку
//             DragTarget<int>(
//               onWillAcceptWithDetails: (draggedIndex) {
//                 _onDragHover(iconDataList.length);
//                 return true;
//               },
//               onLeave: (data) {
//                 setState(() {
//                   hoverIndex = null;
//                 });
//               },
//               onAcceptWithDetails: (draggedIndex) {
//                 _insertDraggedItem(iconDataList.length);
//               },
//               builder: (context, candidateData, rejectedData) {
//                 return AnimatedContainer(
//                   duration: Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   width: hoverIndex == iconDataList.length ? 65.0 : 50.0,
//                   height: 50.0,
//                   color: Colors.green,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // class ReorderableExample extends StatefulWidget {
// //   const ReorderableExample({super.key});
// //
// //   @override
// //   State<ReorderableExample> createState() => _ReorderableListViewExampleState();
// // }
// //
// // class _ReorderableListViewExampleState extends State<ReorderableExample> {
// //   final List<int> _items = List<int>.generate(5, (int index) => index);
// //
// //   bool isOutsideZone = false;
// //   final GlobalKey zoneKey = GlobalKey();
// //
// //   Size containerSize = Size(0.0, 0.0);
// //
// //   int? hoveringIndex;
// //
// //   List<int> overlappingIndexes = [];
// //
// //   void _getContainerSize() {
// //     RenderBox? box = zoneKey.currentContext?.findRenderObject() as RenderBox?;
// //     if (box != null) {
// //       setState(() {
// //         containerSize = box.size;
// //       });
// //     }
// //   }
// //
// //   void _updateOverlappingIndexes(Offset dragOffset) {
// //     List<int> newOverlappingIndexes = [];
// //     final RenderBox itemBox = zoneKey.currentContext!.findRenderObject() as RenderBox;
// //     for (int i = 0; i < _items.length; i++) {
// //       Offset itemPosition = itemBox.localToGlobal(Offset.zero);
// //       Size itemSize = Size(50.0, 50.0);
// //       Size dragSize = Size(50.0, 50.0);
// //
// //       Rect itemRect = Rect.fromLTWH(
// //         itemPosition.dx,
// //         itemPosition.dy,
// //         itemSize.width,
// //         itemSize.height,
// //       );
// //
// //       Rect dragRect = Rect.fromLTWH(
// //         dragOffset.dx,
// //         dragOffset.dy,
// //         dragSize.width,
// //         dragSize.height,
// //       );
// //
// //       if (dragRect.overlaps(itemRect)) {
// //         print('ADD => $i');
// //         newOverlappingIndexes.add(i);
// //       }
// //     }
// //
// //     setState(() {
// //       overlappingIndexes = newOverlappingIndexes;
// //     });
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _getContainerSize();
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         Container(
// //           width: double.infinity,
// //           height: double.infinity,
// //           color: Colors.yellow,
// //         ),
// //         Container(
// //           key: zoneKey,
// //           color: Colors.blue,
// //           child: Row(
// //             mainAxisSize: MainAxisSize.min,
// //             children: List.generate(
// //               5,
// //               (int index) => DragTarget<int>(
// //                 onWillAcceptWithDetails: (data) {
// //                   setState(() {
// //                     hoveringIndex = index;
// //                   });
// //                   return true;
// //                 },
// //                 onLeave: (data) {
// //                   setState(() {
// //                     hoveringIndex = null;
// //                   });
// //                 },
// //                 onAcceptWithDetails: (data) {
// //                   setState(() {
// //                     hoveringIndex = null;
// //                   });
// //                 },
// //                 builder: (
// //                   context,
// //                   candidateData,
// //                   rejectedData,
// //                 ) {
// //                   return Draggable(
// //                     data: index,
// //                     childWhenDragging: Container(
// //                       margin: EdgeInsets.all(10.0),
// //                       width: isOutsideZone ? 0.0 : 50.0,
// //                       height: isOutsideZone ? 0.0 : 50.0,
// //                       color: Colors.blue,
// //                     ),
// //                     feedback: Container(
// //                       alignment: Alignment.center,
// //                       margin: EdgeInsets.all(10.0),
// //                       width: 50.0,
// //                       height: 50.0,
// //                       color: Colors.red,
// //                       child: Material(
// //                         color: Colors.red,
// //                         child: Text('$index'),
// //                       ),
// //                     ),
// //                     onDragUpdate: (details) {
// //                       RenderBox? zoneBox = zoneKey.currentContext?.findRenderObject() as RenderBox?;
// //                       Offset zonePosition = zoneBox?.localToGlobal(Offset.zero) ?? Offset.zero;
// //
// //                       if (details.globalPosition.dx < zonePosition.dx ||
// //                           details.globalPosition.dx > zonePosition.dx + containerSize.width ||
// //                           details.globalPosition.dy < zonePosition.dy ||
// //                           details.globalPosition.dy > zonePosition.dy + containerSize.height) {
// //                         setState(() {
// //                           isOutsideZone = true;
// //                         });
// //                       } else {
// //                         setState(() {
// //                           isOutsideZone = false;
// //                         });
// //                       }
// //
// //                       _updateOverlappingIndexes(details.globalPosition);
// //                     },
// //                     onDragEnd: (details) {
// //                       setState(() {
// //                         isOutsideZone = false;
// //                         overlappingIndexes.clear();
// //                       });
// //                     },
// //                     child: Container(
// //                       alignment: Alignment.center,
// //                       margin: EdgeInsets.all(10.0),
// //                       width: 50.0,
// //                       height: 50.0,
// //                       color: Colors.red,
// //                       child: Text('$index'),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),
// //         ),
// //
// //         Positioned(
// //           top: 350,
// //           left: 100,
// //           child: Text(
// //             '$overlappingIndexes',
// //             style: const TextStyle(fontSize: 20),
// //           ),
// //         ),
// //         // Container(
// //         //   height: 100.0,
// //         //   child: ListView(
// //         //     scrollDirection: Axis.horizontal,
// //         //     padding: const EdgeInsets.symmetric(horizontal: 40),
// //         //     children: <Widget>[
// //         //       for (int index = 0; index < _items.length; index += 1)
// //         //         Draggable<int>(
// //         //           onDragStarted: () {
// //         //             setState(() {
// //         //               // final int item = _items.removeAt(index);
// //         //               // _items.insert(_items.length, item);
// //         //             });
// //         //           },
// //         //           onDragUpdate: (dragUpdateDetails) {
// //         //             print(dragUpdateDetails);
// //         //           },
// //         //           key: Key('$index'),
// //         //           childWhenDragging: Container(
// //         //             width: 100.0,
// //         //             height: 100.0,
// //         //             color: _items[index].isOdd ? oddItemColor : evenItemColor,
// //         //             child: Text('Item ${_items[index]}'),
// //         //           ),
// //         //           feedback: Material(
// //         //             child: Container(
// //         //               width: 100.0,
// //         //               height: 100.0,
// //         //               color: _items[index].isOdd ? oddItemColor : evenItemColor,
// //         //               child: Text('Item ${_items[index]}'),
// //         //             ),
// //         //           ),
// //         //           child: Container(
// //         //             width: 100.0,
// //         //             height: 100.0,
// //         //             color: _items[index].isOdd ? oddItemColor : evenItemColor,
// //         //             child: Text('Item ${_items[index]}'),
// //         //           ),
// //         //         ),
// //         //     ],
// //         //     // onReorder: (int oldIndex, int newIndex) {
// //         //     //   setState(() {
// //         //     //     if (oldIndex < newIndex) {
// //         //     //       newIndex -= 1;
// //         //     //     }
// //         //     //     final int item = _items.removeAt(oldIndex);
// //         //     //     _items.insert(newIndex, item);
// //         //     //   });
// //         //     // },
// //         //   ),
// //         // ),
// //       ],
// //     );
// //   }
// // }
//
// // class DraggableColumnExample extends StatefulWidget {
// //   const DraggableColumnExample({super.key});
// //
// //   @override
// //   State<DraggableColumnExample> createState() => _DraggableColumnExampleState();
// // }
// //
// // class _DraggableColumnExampleState extends State<DraggableColumnExample> {
// //   final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Draggable Column Example'),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: DragTarget<String>(
// //               builder: (context, candidateData, rejectedData) {
// //                 return Container(
// //                   color: Colors.red,
// //                   child: const Center(
// //                     child: Text(
// //                       'Drag here to delete',
// //                       style: TextStyle(color: Colors.white),
// //                     ),
// //                   ),
// //                 );
// //               },
// //               onWillAcceptWithDetails: (data) {
// //                 return true;
// //               },
// //               onAcceptWithDetails: (data) {
// //                 setState(() {
// //                   items.remove(data.data);
// //                 });
// //               },
// //             ),
// //           ),
// //           Expanded(
// //             flex: 4,
// //             child: ReorderableListView(
// //               children: items.map((item) {
// //                 return ListTile(
// //                   key: ValueKey(item),
// //                   title: Text(item),
// //                   tileColor: Colors.grey[200],
// //                 );
// //               }).toList(),
// //               onReorder: (oldIndex, newIndex) {
// //                 setState(() {
// //                   if (oldIndex < newIndex) {
// //                     newIndex -= 1;
// //                   }
// //                   final String item = items.removeAt(oldIndex);
// //                   items.insert(newIndex, item);
// //                 });
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// // import 'package:flutter/material.dart';
// //
// // class ReorderList extends StatelessWidget {
// //   const ReorderList({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       // height: 100.0,
// //       color: Colors.blue,
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: List.generate(5, (index) {
// //           return Container(
// //             margin: EdgeInsets.all(8.0),
// //             width: 100.0,
// //             height: 100.0,
// //             color: Colors.yellow,
// //             child: Center(
// //               child: Text('$index'),
// //             ),
// //           );
// //         }),
// //       ),
// //     );
// //   }
// // }
//
// ///
// // import 'dart:ui';
// //
// // import 'package:animated_reorderable_list/animated_reorderable_list.dart';
// // import 'package:flutter/material.dart';
// // import 'package:macos_doc/item_card.dart';
// //
// // import 'colors.dart';
// //
// // class User {
// //   final String name;
// //   final int id;
// //
// //   User({
// //     required this.name,
// //     required this.id,
// //   });
// // }
// //
// // class ReorderList extends StatefulWidget {
// //   const ReorderList({super.key});
// //
// //   @override
// //   State<ReorderList> createState() => _ReorderListState();
// // }
// //
// // class _ReorderListState extends State<ReorderList> {
// //   AnimationType appliedStyle = AnimationType.fadeIn;
// //   List<User> list = [];
// //
// //   // int addedNumber = 9;
// //   // bool isGrid = true;
// //
// //   List<User> nonDraggableItems = [];
// //   List<User> lockedItems = [];
// //
// //   List<AnimationEffect> animations = [SlideInDown()];
// //   final double itemSpacing = 10.0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     list = List.generate(5, (index) => User(name: "User $index", id: index));
// //     // nonDraggableItems = list.where((user) => user.id == 1).toList();
// //     // lockedItems = list.where((user) => user.id == 0).toList();
// //   }
// //
// //   // void insert() {
// //   //   addedNumber += 1;
// //   //   setState(() {
// //   //     list.insert(1, User(name: "User $addedNumber", id: addedNumber));
// //   //   });
// //   // }
// //   //
// //   // void remove() {
// //   //   setState(() {
// //   //     if (list.isNotEmpty && list.length > 1) list.removeAt(1);
// //   //   });
// //   // }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return LayoutBuilder(builder: (context, constraints) {
// //       print('constraints.maxWidth => ${constraints.maxWidth}');
// //       final int cutters = list.length;
// //       print('cutters => $cutters');
// //       final double spaceForColumns = constraints.maxWidth - (itemSpacing * cutters);
// //       print('spaceForColumns => $spaceForColumns');
// //       final double columnWidth = spaceForColumns / list.length;
// //       print('columnWidth => $columnWidth');
// //       final Size itemSize = Size(columnWidth, columnWidth);
// //       return
// //       //   AnimatedReorderableGridView(
// //       //   shrinkWrap: true,
// //       //   items: list,
// //       //   itemBuilder: (BuildContext context, int index) {
// //       //     final User user = list[index];
// //       //     return ItemCard(
// //       //       key: ValueKey(user.id),
// //       //       id: user.id,
// //       //       dragEnabled: !nonDraggableItems.contains(user),
// //       //       isLocked: lockedItems.contains(user),
// //       //     );
// //       //   },
// //       //   sliverGridDelegate: SliverReorderableGridDelegateWithFixedCrossAxisCount(
// //       //     crossAxisCount: list.length,
// //       //     mainAxisSpacing: 10.0,
// //       //     crossAxisSpacing: 10.0,
// //       //   ),
// //       //   enterTransition: animations,
// //       //   exitTransition: animations,
// //       //   insertDuration: const Duration(milliseconds: 300),
// //       //   removeDuration: const Duration(milliseconds: 300),
// //       //   onReorder: (int oldIndex, int newIndex) {
// //       //     // final Map<User, int> lockedItemPositions = {
// //       //     //   for (int i = 0; i < list.length; i++)
// //       //     //     if (lockedItems.contains(list[i])) list[i]: i
// //       //     // };
// //       //     setState(() {
// //       //       final User user = list.removeAt(oldIndex);
// //       //       list.insert(newIndex, user);
// //       //       // for (var entry in lockedItemPositions.entries) {
// //       //       //   list.remove(entry.key);
// //       //       //   list.insert(entry.value, entry.key); // Insert based on original position (id in this case)
// //       //       // }
// //       //     });
// //       //   },
// //       //   // nonDraggableItems: nonDraggableItems,
// //       //   // lockedItems: lockedItems,
// //       //   dragStartDelay: const Duration(milliseconds: 0),
// //       //   // onReorderEnd: (int index) {
// //       //   //   print(" End index :  $index");
// //       //   // },
// //       //   onReorderStart: (int index) {
// //       //     // print(" Start index :  $index");
// //       //   },
// //       //   // proxyDecorator: proxyDecorator,
// //       //   isSameItem: (a, b) => a.id == b.id,
// //       //
// //       //   /*  A custom builder that is for inserting items with animations.
// //       //
// //       //                               insertItemBuilder: (Widget child, Animation<double> animation){
// //       //                                  return ScaleTransition(
// //       //                                        scale: animation,
// //       //                                        child: child,
// //       //                                      );
// //       //                                     },
// //       //
// //       //
// //       //                       */
// //       //   /*  A custom builder that is for removing items with animations.
// //       //
// //       //                                   removeItemBuilder: (Widget child, Animation<double> animation){
// //       //                                      return ScaleTransition(
// //       //                                        scale: animation,
// //       //                                        child: child,
// //       //                                      );
// //       //                                     },
// //       //                       */
// //       // );
// //     });
// //   }
// // }
// //
// // Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
// //   return AnimatedBuilder(
// //     animation: animation,
// //     builder: (BuildContext context, Widget? child) {
// //       final double animValue = Curves.easeInOut.transform(animation.value);
// //       final double elevation = lerpDouble(0, 6, animValue)!;
// //       return Material(
// //         elevation: elevation,
// //         color: const Color(0x00000000),
// //         shadowColor: primaryColor.withValues(alpha: 0.9),
// //         child: child,
// //       );
// //     },
// //     child: child,
// //   );
// // }
