import 'package:flutter/material.dart';
import 'package:macos_doc/widgets/my_sortable_wrap.dart';

class SortableItem extends StatefulWidget {
  SortableItem({
    required this.element,
    required this.onEventHit,
    super.key,
  }) {
    element.widget = this;
  }

  final OnEventHit onEventHit;
  final SortableElement element;

  @override
  SortableItemState createState() => SortableItemState();
}

class SortableItemState extends State<SortableItem> with TickerProviderStateMixin {
  /// Animations controllers
  late AnimationController slideToRightController;
  late AnimationController slideToLeftController;

  /// Use for creating a clone ghost view when user dragging to different row
  GhostType ghostType = GhostType.none;

  void setGhostType(GhostType type) => setState(() => ghostType = type);

  /// Visible index for rolling from / rolling to
  late int sourceIndex;
  late int destinationIndex;

  /// Start the rolling animation
  void startAnimation(bool isDraggingInSameRow) {
    bool isSlideToRight = destinationIndex > sourceIndex;
    bool isSlideToLeft = destinationIndex < sourceIndex;
    TickerFuture? animationFuture;
    if (isSlideToRight) {
      /// slide to right, use 'reverse', offset.x: -1.0 -> 0.0
      animationFuture = slideToLeftController.reverse(from: 1.0);
    } else if (isSlideToLeft) {
      /// slide to left, use 'reverse', offset.x: 1.0 -> 0.0
      animationFuture = slideToRightController.reverse(from: 1.0);
    }

    /// dragging in the same row/line, just return
    if (isDraggingInSameRow) return;

    /// TODO ... Hit the first/last one, in this case animation effect issue ...
    /// TODO ... Dragging one is the first/last one, in this case animation effect issue

    /// stick a ghost for the last/first position element
    if (isSlideToRight) {
      if (element.isTheLastOne) {
        setGhostType(GhostType.next);
      }
    } else if (isSlideToLeft) {
      if (element.isTheFirstOne) {
        setGhostType(GhostType.previous);
      }
    }
    if (ghostType != GhostType.none) {
      animationFuture?.then((value) {
        setGhostType(GhostType.none);
      });
    }
  }

  /// Data or Relation holder, anyway ...
  SortableElement get element => widget.element;

  @override
  void initState() {
    super.initState();
    slideToRightController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    slideToLeftController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    /// call animation controller first before super.dispose()
    slideToRightController.dispose();
    slideToLeftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    element.state = this;

    /// append capacity of animation
    Widget capacityAnimate(Widget child) {
      child = SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 0.0), end: const Offset(1.0, 0.0)).animate(
          slideToRightController,
        ),
        child: child,
      );
      child = SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 0.0), end: const Offset(-1.0, 0.0)).animate(
          slideToLeftController,
        ),
        child: child,
      );
      return child;
    }

    /// append capacity of able be hit
    Widget capacityHit(Widget child, OnEventHit onEventHit) {
      List<Widget> children = [
        child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: DragTarget<SortableElement>(
            builder: (BuildContext context, List<SortableElement?> candidateData, List<dynamic> rejectedData) {
              return const SizedBox();
              // return ColoredBox(color: Colors.grey.withAlpha(128), child: SizedBox()); // for debug :)
            },
            onWillAcceptWithDetails: (toAccept) {
              // if (toAccept == null) return false;
              onEventHit(this, toAccept.data);
              return true;
            },
            onAcceptWithDetails: (accepted) {},
            onLeave: (leaving) {},
          ),
        ),
      ];

      /// insert or append a ghost/clone view
      if (ghostType != GhostType.none) {
        double spacing = element.parent.widget.spacing;
        double width = element.parent.anyElementSize.width;
        bool isFrontGhost = ghostType == GhostType.previous;
        double left = isFrontGhost ? -width - spacing : width + spacing;
        SortableElement sibling = isFrontGhost ? element.previousToMe : element.nextToMe;
        children.insert(
          isFrontGhost ? 0 : children.length,
          Positioned(
            top: 0,
            bottom: 0,
            left: left,
            child: sibling.view,
          ),
        );
      }
      return Stack(clipBehavior: Clip.none, children: children);
    }

    return capacityAnimate(capacityHit(element.view, widget.onEventHit));
  }
}

/// Data or Relation Model
class SortableElement {
  /// The caller's view
  late Widget view;

  /// The caller's children index, the most original index
  late int originalIndex;

  /// The [SortableWrapState] context/state i'm staying in
  late SortableWrapState parent;

  /// Element index before dragging start
  late int preservedIndex;

  /// The [SortableItem] widget i'm binding to
  late SortableItem widget;

  /// The [SortableItemState] widget i'm binding to, corresponding to this [widget]
  late SortableItemState state;

  /// Element index of on rolling what you are looking at
  int get visibleIndex => parent.animationElements.indexOf(this);

  SortableElement get nextToMe => parent.animationElements[visibleIndex + 1];

  SortableElement get previousToMe => parent.animationElements[visibleIndex - 1];

  /// If is the first one on a row
  bool get isTheFirstOne => isTheFirstOnRow(parent.animationElements);

  /// If is the last one on a row
  bool get isTheLastOne => isTheLastOnRow(parent.animationElements);

  bool isTheFirstOnRow(List<SortableElement> elements) {
    int index = elements.indexOf(this);
    return index != 0 && index % parent.elementCountPerRow == 0;
  }

  bool isTheLastOnRow(List<SortableElement> elements) {
    int index = elements.indexOf(this);
    return index != elements.length - 1 && (index + 1) % parent.elementCountPerRow == 0;
  }
}

enum GhostType { none, previous, next }

typedef OnEventHit = void Function(SortableItemState state, SortableElement accept);
