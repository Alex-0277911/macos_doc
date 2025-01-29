// import 'package:flutter/material.dart';
// import 'package:reorderables/reorderables.dart';
//
// class ReorderableWrapScreen extends StatefulWidget {
//   const ReorderableWrapScreen({super.key});
//
//   @override
//   State<ReorderableWrapScreen> createState() => _ReorderableWrapScreenState();
// }
//
// class _ReorderableWrapScreenState extends State<ReorderableWrapScreen> {
//   final double _iconSize = 90;
//   List<Widget> _tiles = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _tiles = <Widget>[
//       Icon(Icons.filter_1, size: _iconSize),
//       Icon(Icons.filter_2, size: _iconSize),
//       Icon(Icons.filter_3, size: _iconSize),
//       Icon(Icons.filter_4, size: _iconSize),
//       Icon(Icons.filter_5, size: _iconSize),
//       Icon(Icons.filter_6, size: _iconSize),
//       Icon(Icons.filter_7, size: _iconSize),
//       Icon(Icons.filter_8, size: _iconSize),
//       Icon(Icons.filter_9, size: _iconSize),
//     ];
//   }
//
//   void _onReorder(int oldIndex, int newIndex) {
//     setState(() {
//       Widget row = _tiles.removeAt(oldIndex);
//       _tiles.insert(newIndex, row);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ReorderableWrap wrap = ReorderableWrap(
//       needsLongPressDraggable: false,
//       spacing: 8.0,
//       runSpacing: 4.0,
//       padding: const EdgeInsets.all(8),
//       onReorder: _onReorder,
//       onNoReorder: (int index) {
//         //this callback is optional
//         debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
//       },
//       onReorderStarted: (int index) {
//         //this callback is optional
//         debugPrint('${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
//       },
//       children: _tiles,
//     );
//
//     return SingleChildScrollView(
//       child: Center(child: wrap),
//     );
//   }
// }
