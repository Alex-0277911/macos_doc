// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:macos_doc/core/providers/riverpod_providers.dart';
//
// class GridItem extends ConsumerWidget {
//   final IconData icon;
//   final int index;
//
//   const GridItem({
//     required this.icon,
//     required this.index,
//     super.key,
//   });
//
//   double _getScaleForIndex(List<int> listIndexes, int hoveredIndex) {
//     if (hoveredIndex == -2) {
//       return 1.0;
//     }
//
//     /// hoveredIndex => value element (index)
//     /// indexHoveredElement => number element in list
//     final int indexHoveredElement = listIndexes.indexOf(hoveredIndex);
//     final int previousIndex = indexHoveredElement - 1;
//     final int nextIndex = indexHoveredElement + 1;
//
//     if (previousIndex >= 0 && index == listIndexes[previousIndex]) {
//       return 1.1;
//     }
//     if (nextIndex <= listIndexes.length - 1 && index == listIndexes[nextIndex]) {
//       return 1.1;
//     }
//
//     if (index == hoveredIndex) {
//       return 1.2;
//     } else {
//       return 1.0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final int hoveredIndex = ref.watch(hoveredIndexProvider);
//     final List<int> listIndexes = List.from(ref.watch(indexesItemsProvider));
//     final bool isDragging = ref.watch(draggingElementProvider).$1;
//     return MouseRegion(
//       onEnter: ((event) {
//         ref.read(hoveredIndexProvider.notifier).update(index);
//       }),
//       onExit: (event) {
//         ref.read(hoveredIndexProvider.notifier).update(-2);
//       },
//       child: AnimatedScale(
//         alignment: Alignment.bottomCenter,
//         duration: const Duration(milliseconds: 100),
//         scale: isDragging ? 1.0 : _getScaleForIndex(listIndexes, hoveredIndex),
//         child: Container(
//           constraints: const BoxConstraints(minWidth: 48.0),
//           height: 48.0,
//           margin: const EdgeInsets.all(8.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8.0),
//             color: Colors.primaries[icon.hashCode % Colors.primaries.length],
//           ),
//           child: Center(child: Icon(icon, color: Colors.white)),
//         ),
//       ),
//     );
//   }
// }
