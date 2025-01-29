import 'package:flutter/material.dart';

class IconDragAndDrop extends StatefulWidget {
  const IconDragAndDrop({super.key});

  @override
  State<IconDragAndDrop> createState() => _IconDragAndDropState();
}

class _IconDragAndDropState extends State<IconDragAndDrop> {
  List<Widget> listWidgets = [
    Icon(
      Icons.home,
      color: Colors.blue,
      size: 60,
    ),
    Container(
      color: Colors.red,
    ),
    Icon(
      Icons.star,
      color: Colors.blue,
      size: 60,
    ),
    Container(
      color: Colors.red,
    ),
    Icon(
      Icons.settings,
      color: Colors.blue,
      size: 60,
    ),
    Container(
      color: Colors.red,
    ),
    Icon(
      Icons.search,
      color: Colors.blue,
      size: 60,
    ),
    Container(
      color: Colors.red,
    ),
    Icon(
      Icons.favorite,
      color: Colors.blue,
      size: 60,
    ),
    Container(
      color: Colors.red,
    ),
  ];

  int? draggingIndex;
  int? targetIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // width: 300,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(listWidgets.length, (index) {
            return Draggable<int>(
              data: index,
              feedback: listWidgets[index],
              childWhenDragging: const SizedBox(width: 0),
              onDragStarted: () {
                setState(() {
                  draggingIndex = index;
                });
              },
              onDragEnd: (_) {
                setState(() {
                  draggingIndex = null;
                });
              },
              child: DragTarget<int>(
                onWillAcceptWithDetails: (data) {
                  setState(() {
                    targetIndex = index;
                  });
                  return true;
                },
                onLeave: (data) {
                  setState(() {
                    targetIndex = null;
                  });
                },
                onAcceptWithDetails: (data) {
                  setState(() {
                    final Widget item = listWidgets.removeAt(data.data);
                    listWidgets.insert(index, item);
                    targetIndex = null;
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  final bool isDraggingOver = targetIndex == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isDraggingOver ? 70 : 50,
                    height: isDraggingOver ? 70 : 50,
                    child: listWidgets[index],
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
