import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_doc/core/providers/riverpod_providers.dart';
import 'package:macos_doc/widgets/my_sortable_utils.dart';
import 'package:macos_doc/widgets/my_sortable_wrap.dart';

/// Entrypoint of the application.
void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  double scaleHovered(int? hoveredIndex, int index) {
    double scale = 1.0;
    if (hoveredIndex != null) {
      if (index == hoveredIndex) {
        scale = 1.4;
      } else if ((index - hoveredIndex).abs() == 1) {
        scale = 1.2;
      }
    }
    return scale;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (IconData e) {
              return Container(
                constraints: const BoxConstraints(minWidth: 48),
                height: 48.0,
                width: 48.0,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.primaries[e.hashCode % Colors.primaries.length],
                ),
                child: Center(child: Icon(e, color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T> extends ConsumerStatefulWidget {
  const Dock({
    this.items = const [],
    required this.builder,
    super.key,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  ConsumerState<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends ConsumerState<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  /// my data array
  List<int> dataArray = [];

  // double scale = 1.0;
  //
  // double scaleValue(int? hoveredIndex, int index) {
  //   double scale = 1.0;
  //   if (hoveredIndex != null) {
  //     if (index == hoveredIndex) {
  //       scale = 1.4;
  //     } else if ((index - hoveredIndex).abs() == 1) {
  //       scale = 1.2;
  //     }
  //   }
  //   print('hoveredIndex => $hoveredIndex');
  //   print('index => $index');
  //   print('scale => $scale');
  //   return scale;
  // }

  @override
  void initState() {
    super.initState();

    dataArray.clear();
    dataArray = List.generate(_items.length, (int index) => index);
    // for (int i = 0; i < _items.length; i++) {
    //   dataArray.add(i);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final int? hoveredIndex = ref.watch(hoveredIndexProvider);
    List<Widget> children = _items.map(widget.builder).toList();
    // List<Widget> children = [
    //   for (int i = 0; i < _items.length; i++) //widget.builder(_items[i])
    //     GestureDetector(
    //       onTap: () {
    //         print('SET SCALE => 1.4');
    //         setState(() {
    //           scale = 1.4;
    //         });
    //       },
    //       child: AnimatedContainer(
    //         key: ValueKey(i),
    //         duration: const Duration(milliseconds: 500),
    //         // constraints: const BoxConstraints(minWidth: 48),
    //         height: 48.0 * scale,
    //         // height: 48.0 * scaleValue(hoveredIndex, i),
    //         width: 48.0 * scale,
    //         // width: 48.0 * scaleValue(hoveredIndex, i),
    //         margin: const EdgeInsets.all(8.0),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(8.0),
    //           color: Colors.primaries[_items[i].hashCode % Colors.primaries.length],
    //         ),
    //         child: Center(child: Icon(_items[i] as IconData, color: Colors.white)),
    //       ),
    //     )
    // ];

    ///
    SortableWrapOptions options = SortableWrapOptions();
    options.draggableFeedbackBuilder = (Widget child) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        child: Opacity(
          opacity: 0.8,
          child: child,
        ),
      );
    };

    ///
    return MouseRegion(
      onHover: (event) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset localPosition = box.globalToLocal(event.position);
        final int hoveredIdx = ((localPosition.dx) / 66.0).floor().clamp(0, dataArray.length - 1);
        if (hoveredIndex != hoveredIdx) {
          ref.read(hoveredIndexProvider.notifier).update(hoveredIdx);
        }
      },
      onEnter: (event) {
        ref.read(isOutsideProvider.notifier).update(false);
      },
      onExit: (event) {
        ref.read(isOutsideProvider.notifier).update(true);
        if (hoveredIndex != null) {
          ref.read(hoveredIndexProvider.notifier).update(null);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.black12,
        ),
        padding: const EdgeInsets.all(4.0),
        child: SortableWrap(
          onSorted: (int oldIndex, int newIndex) {
            setState(() {
              dataArray.insert(newIndex, dataArray.removeAt(oldIndex));
              iDebugLog('Data sorted after >>>>>: $dataArray');
            });
          },
          onSortStart: (int index) {
            iDebugLog('Data sorted before >>>>>: $dataArray');
          },
          options: options,
          children: children,
        ),
      ),
    );
  }
}

///
///

// void main() {
//   runApp(
//     ProviderScope(
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: App(),
//       ),
//     ),
//   );
// }

// class App extends ConsumerStatefulWidget {
//   const App({super.key});
//
//   @override
//   AppState createState() => AppState();
// }
//
// class AppState extends ConsumerState<App> {
//   List<int> yourDataArray = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     yourDataArray.clear();
//     for (int i = 0; i < 5; i++) {
//       yourDataArray.add(i);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isOutside = ref.watch(isOutsideProvider);
//     iDebugLog('App rebuild!!!!');
//     Color alphaColor(Color color, {int alpha = 128}) => color.withAlpha(alpha);
//     List<Color> colors = [
//       Colors.redAccent,
//       Colors.blueAccent,
//       Colors.pinkAccent,
//       Colors.greenAccent,
//       Colors.amberAccent,
//       Colors.purpleAccent,
//     ];
//     colors = colors.map((e) => alphaColor(e)).toList();
//     Widget boxText(String text) => SizedBox(
//           width: 72.0,
//           height: 72.0,
//           child: Center(
//             child: Text(
//               text,
//             ),
//           ),
//         );
//     List<Widget> children = [
//       for (int i = 0; i < yourDataArray.length; i++)
//         ColoredBox(
//           color: colors[yourDataArray[i] % colors.length],
//           child: boxText(
//             '${yourDataArray[i]}',
//           ),
//         )
//     ];
//
//     SortableWrapOptions options = SortableWrapOptions();
//     options.draggableFeedbackBuilder = (Widget child) {
//       return Material(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.zero,
//         child: Opacity(
//           opacity: 0.8,
//           child: Card(
//             child: child,
//           ),
//         ),
//       );
//     };
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Align(
//             alignment: Alignment.topCenter,
//             child: Column(
//               children: [
//                 Text(
//                   'isOutside => $isOutside',
//                   style: TextStyle(
//                     color: isOutside ? Colors.red : Colors.blue,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: MouseRegion(
//               hitTestBehavior: HitTestBehavior.translucent,
//               onEnter: (event) {
//                 ref.read(isOutsideProvider.notifier).update(false);
//               },
//               onExit: (event) {
//                 ref.read(isOutsideProvider.notifier).update(true);
//               },
//               child: Container(
//                 padding: EdgeInsets.all(32.0),
//                 color: Colors.red.shade100,
//                 child: SortableWrap(
//                   onSorted: (int oldIndex, int newIndex) {
//                     setState(() {
//                       yourDataArray.insert(newIndex, yourDataArray.removeAt(oldIndex));
//                       iDebugLog('Data sorted after >>>>>: $yourDataArray');
//                     });
//                   },
//                   onSortStart: (int index) {
//                     iDebugLog('Data sorted before >>>>>: $yourDataArray');
//                   },
//                   spacing: 10.0,
//                   options: options,
//                   children: children,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // void goToNextPage() {
//   //   Navigator.of(context, rootNavigator: true).push(PageRouteBuilder(
//   //     pageBuilder: (ctx, one, two) => const PageNext(),
//   //     transitionsBuilder: (ctx, one, two, child) => SlideTransition(
//   //       position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(one),
//   //       child: child,
//   //     ),
//   //   ));
//   // }
// }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:macos_doc/core/providers/riverpod_providers.dart';
//
// enum Directions { right, links }
//
// void main() {
//   runApp(ProviderScope(child: const MyApp()));
// }
//
// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final bool isOutside = ref.watch(isOutsideProvider);
//     final int? hoveredIndex = ref.watch(hoveredIndexProvider);
//     final int? draggedIndex = ref.watch(draggedIndexProvider);
//     final int? insertIndex = ref.watch(insertIndexProvider);
//     final Directions? directionsMovement = ref.watch(directionsMovementProvider);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Stack(
//           children: [
//             Align(
//               alignment: Alignment.topCenter,
//               child: Column(
//                 children: [
//                   Text(
//                     'isOutside => $isOutside',
//                     style: TextStyle(
//                       color: isOutside ? Colors.red : Colors.blue,
//                     ),
//                   ),
//                   Text(
//                     'hoveredIndex => $hoveredIndex',
//                   ),
//                   Text(
//                     'draggedIndex => $draggedIndex',
//                   ),
//                   Text(
//                     'insertIndex => $insertIndex',
//                   ),
//                   Text(
//                     'directionsMovement => $directionsMovement',
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20.0),
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16.0),
//                   child: Dock(
//                     items: const [
//                       Icons.person,
//                       Icons.message,
//                       Icons.call,
//                       Icons.camera,
//                       Icons.photo,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Dock extends ConsumerStatefulWidget {
//   final List<IconData> items;
//
//   const Dock({
//     required this.items,
//     super.key,
//   });
//
//   @override
//   ConsumerState<Dock> createState() => _DockState();
// }
//
// class _DockState extends ConsumerState<Dock> {
//   // int? draggedIndex;
//   // Offset? dragOffset;
//   List<IconData> currentItems = [];
//
//   // bool isOutside = false;
//   // int? insertIndex;
//
//   final GlobalKey containerKey = GlobalKey();
//
//   @override
//   void initState() {
//     currentItems = List.from(widget.items);
//     // ref.read(currentItemsProvider.notifier).update(List.from(widget.items));
//     super.initState();
//   }
//
//   bool isOutsideDock(Offset? offset) {
//     if (offset == null) return false;
//     final RenderBox box = context.findRenderObject() as RenderBox;
//     final Size size = box.size;
//     return offset.dx < -20.0 || offset.dx > size.width + 20.0 || offset.dy < -20.0 || offset.dy > size.height + 20.0;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final int? hoveredIndex = ref.watch(hoveredIndexProvider);
//     final int? draggedIndex = ref.watch(draggedIndexProvider);
//     // final Offset? dragOffset = ref.watch(dragOffsetProvider);
//     final bool isOutside = ref.watch(isOutsideProvider);
//     final int? insertIndex = ref.watch(insertIndexProvider);
//     final bool isDragged = ref.watch(isDraggedProvider);
//     return Container(
//       key: containerKey,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16.0),
//         color: Colors.black.withValues(alpha: 0.2),
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//       child: MouseRegion(
//         hitTestBehavior: HitTestBehavior.translucent,
//         onHover: (event) {
//           final RenderBox box = context.findRenderObject() as RenderBox;
//           final Offset localPosition = box.globalToLocal(event.position);
//           final int hoveredIdx = ((localPosition.dx - 12.0) / 72.0).floor().clamp(0, currentItems.length - 1);
//           ref.read(hoveredIndexProvider.notifier).update(hoveredIdx);
//         },
//         onExit: (event) {
//           ref.read(hoveredIndexProvider.notifier).update(null);
//         },
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: List.generate(currentItems.length + 1, (int index) {
//             print('LIST GENERATE');
//             // if (insertIndex != null && index == insertIndex && draggedIndex != null) {
//             //   return const InsertPlaceholder();
//             // }
//             // if (insertIndex != null && index > insertIndex && draggedIndex != null) {
//             //   index -= 1;
//             // }
//             if (index == currentItems.length) {
//               // return SizedBox.shrink();
//               return Container(
//                 width: 10.0,
//                 height: 64.0,
//                 color: Colors.red,
//               );
//             } else {
//               double scale = 1.0;
//               if (hoveredIndex != null && draggedIndex == null) {
//                 if (index == hoveredIndex) {
//                   scale = 1.4;
//                 } else if ((index - hoveredIndex).abs() == 1) {
//                   scale = 1.2;
//                 }
//               }
//               return Draggable<int>(
//                 hitTestBehavior: HitTestBehavior.translucent,
//                 data: index,
//                 feedback: Opacity(
//                   opacity: 0.8,
//                   child: DockItem(
//                     icon: currentItems[index],
//                     scale: 1.0,
//                   ),
//                 ),
//                 childWhenDragging: DragPlaceholder(
//                   // isOutside: insertIndex != null || isOutside,
//                   isOutside: isOutside,
//                 ),
//                 onDragStarted: () {
//                   ref.read(isDraggedProvider.notifier).update(true);
//                   ref.read(isOutsideProvider.notifier).update(false);
//                   ref.read(draggedIndexProvider.notifier).update(index);
//                   if (insertIndex != index) {
//                     ref.read(insertIndexProvider.notifier).update(index);
//                   }
//
//                   // setState(() {
//                   //   // draggedIndex = index;
//                   //   // isOutside = false;
//                   //   // insertIndex = null;
//                   // });
//                 },
//                 onDragUpdate: (DragUpdateDetails details) {
//                   // /// визначення над яким компонентом перетігуємо іконку
//                   // final RenderBox containerBox = containerKey.currentContext?.findRenderObject() as RenderBox;
//                   // final Offset containerLocalPosition = containerBox.globalToLocal(details.localPosition);
//                   // final int hoveredIdx =
//                   //     ((containerLocalPosition.dx - 12.0) / 72.0).floor().clamp(0, currentItems.length - 1);
//                   // ref.read(hoveredIndexProvider.notifier).update(hoveredIdx);
//
//                   ///
//                   /// визначення напрямку руху при переміщенні іконки
//                   if (details.delta.dx > 0) {
//                     ref.read(directionsMovementProvider.notifier).update(Directions.right);
//                   } else if (details.delta.dx < 0) {
//                     ref.read(directionsMovementProvider.notifier).update(Directions.links);
//                   }
//
//                   ///
//                   final RenderBox box = context.findRenderObject() as RenderBox;
//                   final Offset localPosition = box.globalToLocal(details.globalPosition);
//                   final int newIndex = (localPosition.dx / 72.0).floor().clamp(0, currentItems.length - 1);
//                   // final int newIndex = ((localPosition.dx - 12.0) / 72.0).floor().clamp(0, currentItems.length - 1);
//                   if (insertIndex != newIndex) {
//                     ref.read(insertIndexProvider.notifier).update(newIndex);
//                   }
//                   ref.read(isOutsideProvider.notifier).update(isOutsideDock(localPosition));
//
//                   /// додавання віджета заповнювача в місце вставки іконки
//                   if (!isOutside && insertIndex != null && draggedIndex != null && insertIndex != draggedIndex) {
//                     if (insertIndex != newIndex) {
//                       setState(() {
//                         print('DELETE DRAGGED WIDGET');
//                         final IconData item = currentItems.removeAt(draggedIndex);
//                         currentItems.insert(insertIndex, item);
//                       });
//                     }
//
//                     /// якщо рухаємося вліво, то вставляємо в місце insertIndex
//                     /// наприклад видаляємо 4 і вставляємо на місце 3
//
//                     // if (insertIndex > draggedIndex) {
//                     //   // insertIndex = insertIndex! - 1;
//                     //   ref.read(insertIndexProvider.notifier).update(insertIndex - 1);
//                     // }
//                     // currentItems.insert(insertIndex, item);
//                   }
//
//                   ///
//                   // ref.read(dragOffsetProvider.notifier).update(localPosition);
//                   // dragOffset = localPosition;
//                   // isOutside = isOutsideDock(dragOffset);
//                   // setState(() {
//                   // print('newIndex != draggedIndex => ${newIndex != draggedIndex}');
//                   // print('newIndex => $newIndex');
//                   // print('draggedIndex => $draggedIndex');
//                   // if (!isOutside && newIndex != draggedIndex) {
//                   // print('insertIndex => $insertIndex');
//                   // print('draggedIndex => $draggedIndex');
//                   // if (!isOutside && newIndex != draggedIndex) {
//                   // insertIndex = newIndex;
//                   // ref.read(insertIndexProvider.notifier).update(newIndex);
//                   // } else {
//                   // insertIndex = null;
//                   // ref.read(insertIndexProvider.notifier).update(null);
//                   // }
//                   // });
//                 },
//                 onDragEnd: (DraggableDetails details) {
//                   ref.read(isDraggedProvider.notifier).update(false);
//                   ref.read(isOutsideProvider.notifier).update(false);
//                   ref.read(draggedIndexProvider.notifier).update(null);
//                   ref.read(insertIndexProvider.notifier).update(null);
//                   ref.read(directionsMovementProvider.notifier).update(null);
//                   // setState(() {
//                   // if (!isOutside && insertIndex != null && insertIndex != draggedIndex) {
//                   //   final IconData item = currentItems.removeAt(draggedIndex!);
//                   //   if (insertIndex > draggedIndex) {
//                   //     // insertIndex = insertIndex! - 1;
//                   //     ref.read(insertIndexProvider.notifier).update(insertIndex - 1);
//                   //   }
//                   //   currentItems.insert(insertIndex, item);
//                   // }
//                   // draggedIndex = null;
//                   // dragOffset = null;
//                   // isOutside = false;
//                   // insertIndex = null;
//                   // });
//                   // ref.read(dragOffsetProvider.notifier).update(null);
//                 },
//                 child: DragTarget<int>(
//                   builder: (context, candidateData, rejectedData) {
//                     return DockItem(
//                       icon: currentItems[index],
//                       scale: scale,
//                     );
//                   },
//                   onWillAcceptWithDetails: (DragTargetDetails<int> data) {
//                     return data.data != index;
//                     // return true;
//                   },
//                   onAcceptWithDetails: (DragTargetDetails<int> data) {
//                     setState(() {
//                       final IconData item = currentItems.removeAt(data.data);
//                       // print('currentItems.removeAt(index) => ${data.data}');
//                       currentItems.insert(index, item);
//                       // print('currentItems.insert(index) => $index => $item');
//                     });
//                   },
//                 ),
//               );
//             }
//           }),
//         ),
//       ),
//     );
//   }
// }
//
// class DockItem extends StatelessWidget {
//   final IconData icon;
//   final double scale;
//
//   const DockItem({
//     required this.icon,
//     this.scale = 1.0,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 64.0,
//       height: 64.0,
//       margin: const EdgeInsets.symmetric(horizontal: 4.0),
//       child: Center(
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           curve: Curves.easeOutQuad,
//           width: 48.0 * scale,
//           height: 48.0 * scale,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8 * scale),
//             color: Colors.primaries[icon.hashCode % Colors.primaries.length],
//           ),
//           child: Center(
//             child: Icon(
//               icon,
//               color: Colors.white,
//               size: 24 * scale,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DragPlaceholder extends StatelessWidget {
//   final bool isOutside;
//
//   const DragPlaceholder({
//     this.isOutside = false,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       curve: Curves.easeOutQuad,
//       width: isOutside ? 30.0 : 64.0,
//       color: isOutside ? Colors.yellow : Colors.green,
//       height: 64.0,
//       margin: const EdgeInsets.symmetric(horizontal: 4.0),
//     );
//   }
// }
//
// class InsertPlaceholder extends StatelessWidget {
//   const InsertPlaceholder({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 64.0,
//       height: 64.0,
//       margin: const EdgeInsets.symmetric(horizontal: 4.0),
//       decoration: BoxDecoration(
//         color: Colors.blue.withValues(alpha: 0.3),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//     );
//   }
// }

/// /////////////////////////////////////////////////////////////////////

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'icon_drag_and_drop.dart';
//
// void main() {
//   runApp(ProviderScope(
//     child: const MainApp(),
//   ));
// }
//
// class MainApp extends StatelessWidget {
//   const MainApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: IconDragAndDrop(),
//         // body: DraggableGrid(
//         //   title: 'Draggable GridView',
//         // ),
//       ),
//     );
//   }
// }
//
// /// Dock of the reorderable [items].
// class Dock<T> extends StatefulWidget {
//   const Dock({
//     super.key,
//     this.items = const [],
//     required this.builder,
//   });
//
//   /// Initial [T] items to put in this [Dock].
//   final List<T> items;
//
//   /// Builder building the provided [T] item.
//   final Widget Function(T) builder;
//
//   @override
//   State<Dock<T>> createState() => _DockState<T>();
// }
//
// /// State of the [Dock] used to manipulate the [_items].
// class _DockState<T> extends State<Dock<T>> {
//   /// [T] items being manipulated.
//   late final List<T> _items = widget.items.toList();
//
//   ///
//   final List<double> itemSizes = List.generate(5, (index) => 100.0);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.0),
//         color: Colors.black12,
//       ),
//       padding: const EdgeInsets.all(4.0),
//       child: AnimatedSize(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisSize: MainAxisSize.min,
//           // children: _items.map(widget.builder).toList(),
//           children: [],
//           // List.generate(
//           //   _items.length,
//           //   (index) {
//           //     return Draggable<int>(
//           //       data: index,
//           //       feedback: SizedBox(
//           //         width: itemSizes[index],
//           //         height: itemSizes[index],
//           //         child: Container(
//           //           margin: EdgeInsets.all(8.0),
//           //           color: Colors.blue,
//           //         ),
//           //       ),
//           //       childWhenDragging: SizedBox(
//           //         width: itemSizes[index],
//           //         height: itemSizes[index],
//           //         child: Container(
//           //           margin: EdgeInsets.all(8.0),
//           //           color: Colors.grey,
//           //         ),
//           //       ),
//           //       onDragStarted: () {
//           //         setState(() {
//           //           itemSizes[index] = 80.0;
//           //         });
//           //       },
//           //       onDragEnd: (details) {
//           //         setState(() {
//           //           itemSizes[index] = 100.0;
//           //         });
//           //       },
//           //       child: SizedBox(
//           //         width: itemSizes[index],
//           //         height: itemSizes[index],
//           //         child: Container(
//           //           margin: EdgeInsets.all(8.0),
//           //           color: Colors.blue,
//           //         ),
//           //       ),
//           //     );
//           //   },
//           // ),
//         ),
//       ),
//     );
//   }
// }
