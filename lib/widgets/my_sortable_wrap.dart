import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_doc/core/providers/riverpod_providers.dart';
import 'package:macos_doc/widgets/my_sortable_item.dart';
import 'package:macos_doc/widgets/my_sortable_utils.dart';

class SortableWrap extends ConsumerStatefulWidget {
  const SortableWrap({
    required this.children,
    required this.onSorted,
    this.onSortStart,
    this.onSortCancel,
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.options,
    super.key,
  });

  final List<Widget> children;

  /// Events
  final void Function(int oldIndex, int newIndex) onSorted;
  final void Function(int index)? onSortStart;
  final void Function(int index)? onSortCancel;

  /// TODO ... To complete the remaining properties that need to pass to [Wrap] ...
  /// Properties pass to the official [Wrap] widget
  final double spacing;
  final double runSpacing;

  /// Widget settings
  final SortableWrapOptions? options;

  @override
  ConsumerState<SortableWrap> createState() => SortableWrapState();
}

class SortableWrapState extends ConsumerState<SortableWrap> {
  /// BuildContexts & Size & Count Properties, use them after determined
  late BuildContext wrapperContext;
  late BuildContext anyElementContext;
  late Size wrapperSize;
  late Size anyElementSize;
  late int elementCountPerRow;
  late int elementCountPerColumn;

  /// Dragging & Index Properties
  SortableElement? draggingElement;

  bool get isDragging => draggingElement != null;

  bool isDraggingMe(SortableElement e) => draggingElement == e;

  /// Cached array that keep the index status before swap on rolling
  List<SortableElement> preservedElements = [];

  /// Cached array that representing the realtime swap index when a drag is under way
  List<SortableElement> animationElements = [];

  /// Widget settings
  SortableWrapOptions? _options;

  SortableWrapOptions get options => widget.options ?? (_options ??= SortableWrapOptions());

  @override
  void initState() {
    super.initState();
    initCachedWithChildren();
  }

  @override
  void didUpdateWidget(covariant SortableWrap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length) {
      /// TODO ... enhance when dragging ...
      initCachedWithChildren();
    }
  }

  void initCachedWithChildren() {
    preservedElements.clear();
    for (int i = 0; i < widget.children.length; i++) {
      SortableElement e = SortableElement();
      e.view = widget.children[i];
      e.originalIndex = i;
      e.parent = this;
      preservedElements.add(e);
    }
    syncPreservedCacheIndexes();

    animationElements.clear();
    animationElements.addAll(preservedElements);
  }

  void syncPreservedCacheIndexes() {
    for (int i = 0; i < preservedElements.length; i++) {
      preservedElements[i].preservedIndex = i;
    }
  }

  @override
  void dispose() {
    super.dispose();

    /// clear cached
    draggingElement = null;
    preservedElements.clear();
    animationElements.clear();
  }

  double scaleValue(int? hoveredIndex, int index) {
    double scale = 1.0;
    if (hoveredIndex != null) {
      if (index == hoveredIndex) {
        scale = 1.15;
      } else if ((index - hoveredIndex).abs() == 1) {
        scale = 1.08;
      }
    }
    return scale;
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutside = ref.watch(isOutsideProvider);
    final int? hoveredIndex = ref.watch(hoveredIndexProvider);
    Widget builder = Builder(
      builder: (context) {
        wrapperContext = context;
        return Wrap(
          spacing: widget.spacing,
          runSpacing: widget.runSpacing,
          children: animationElements
              .map(
                (e) => enclosedWithDraggable(e, isOutside, hoveredIndex),
              )
              .toList(),
        );
      },
    );
    // return ColoredBox(color: Colors.grey, child: builder); // for debug :)
    Widget clip(Widget child) => ClipRect(child: child);
    return clip(builder);
  }

  /// Wrapped with draggable widget
  Widget enclosedWithDraggable(SortableElement element, bool isOutside, int? hoveredIndex) {
    int index = preservedElements.indexOf(element);

    /// A. Return the widget in dragging mode
    if (isDragging) {
      if (isDraggingMe(element)) {
        return IgnorePointer(
          ignoring: true,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: isOutside ? 0.0 : 72.0,
          ),
        );
      } else {
        return SortableItem(
          key: ValueKey(index),
          element: element,
          onEventHit: eventDoRollingInDragging,
        );
      }
    }

    /// B. Return the widget in idle mode
    void safeInvoke(VoidCallback fn) {
      try {
        fn();
      } catch (e, s) {
        iDebugLog('❗👠🩸 ERROR! please check it out: $e, $s');
      }
    }

    /// Drag finish (end/complete/canceled) callback
    void onDragFinished() async {
      int newIndex = element.visibleIndex;
      int oldIndex = element.preservedIndex;
      setState(() {
        /// synchronize cache preserved elements with animation elements
        preservedElements.clear();
        preservedElements.addAll(animationElements);
        syncPreservedCacheIndexes();

        draggingElement = null;
      });

      /// invoke caller's callback
      safeInvoke(() {
        if (oldIndex == newIndex) {
          widget.onSortCancel?.call(oldIndex);
        } else {
          widget.onSorted(oldIndex, newIndex);
        }
      });
    }

    /// Drag started callback
    void onDragStarted() {
      iDebugLog('Drag start index: $index');
      iDebugLog('Context\'s size: ${wrapperContext.size}');
      iDebugLog('Element\'s size: ${anyElementContext.size}');

      /// calculate the row & column & count/size at this moment, for window may resizeable when running as Desktop App
      assert(wrapperContext.size != null, 'Wrap\'s size cannot be determined!');
      assert(anyElementContext.size != null, 'Element\'s size cannot be determined!');
      wrapperSize = wrapperContext.size!;
      anyElementSize = anyElementContext.size!;
      double width = wrapperSize.width;
      double height = wrapperSize.height;
      double ew = anyElementSize.width;
      double eh = anyElementSize.height;
      elementCountPerRow = width ~/ ew;
      elementCountPerColumn = height ~/ eh;
      iDebugLog('[START] count on per row: $elementCountPerRow, count on per column: $elementCountPerColumn');
      while (elementCountPerRow * ew + (elementCountPerRow - 1) * widget.spacing > width) {
        elementCountPerRow--;
      }
      while (elementCountPerColumn * eh + (elementCountPerColumn - 1) * widget.runSpacing > height) {
        elementCountPerColumn--;
      }
      iDebugLog('[FINAL] count on per row: $elementCountPerRow, count on per column: $elementCountPerColumn');

      /// set current dragging element
      setState(() {
        draggingElement = element;
      });

      ///
      ref.read(draggingElementProvider.notifier).update(element);

      /// invoke caller's callback
      safeInvoke(() => widget.onSortStart?.call(element.preservedIndex));
    }

    /// Drag end callback
    void onDragEnd(DraggableDetails details) {
      onDragFinished();
    }

    /// Drag complete callback
    void onDragCompleted() {
      onDragFinished();
    }

    /// Drag canceled callback
    void onDraggableCanceled(Velocity velocity, Offset offset) async {
      final bool isOutside = ref.watch(isOutsideProvider);
      if (isOutside) {
        ref.read(endDragPositionProvider.notifier).update(offset);
        ref.read(animationDragWidgetProvider.notifier).update(true);
        await Future.delayed(const Duration(milliseconds: 300));
        ref.read(animationDragWidgetProvider.notifier).update(false);
      }

      onDragFinished();
    }

    /// a key is needed, for keeping DraggableState when inner setState called.
    ValueKey valueKey = ValueKey(index);
    Widget childBuilder = Builder(builder: (context) {
      /// cache a context for calculate size on starting drag
      anyElementContext = context;
      return options.draggableChildBuilder?.call(element.view) ?? element.view;
    });
    return options.isLongPressDraggable
        ? LongPressDraggable<SortableElement>(
            /// the data passing to DragTarget and its callbacks
            data: element,
            key: valueKey,
            feedback: options.draggableFeedbackBuilder(element.view),
            onDragEnd: onDragEnd,
            onDragStarted: onDragStarted,
            onDragCompleted: onDragCompleted,
            onDraggableCanceled: onDraggableCanceled,
            child: childBuilder,
          )
        :

        /// mouseover animation: the center element and neighboring elements are scaled
        AnimatedScale(
            alignment: Alignment.bottomCenter,
            scale: scaleValue(hoveredIndex, element.visibleIndex),
            duration: const Duration(milliseconds: 100),
            child: Draggable<SortableElement>(
              /// the data passing to DragTarget and its callbacks
              data: element,
              key: valueKey,
              feedback: options.draggableFeedbackBuilder(element.view),
              onDragEnd: onDragEnd,
              onDragStarted: onDragStarted,
              onDragCompleted: onDragCompleted,
              onDraggableCanceled: onDraggableCanceled,
              child: childBuilder,
            ),
          );
  }

  /// Events
  void eventDoRollingInDragging(SortableItemState beHitItemState, SortableElement holdingElement) {
    assert(draggingElement != null, 'Dragging status is a mess now, please check it out.');
    assert(draggingElement == holdingElement, 'Got a different dragging view, please check it out.');

    SortableElement dragging = draggingElement!;
    SortableElement element = beHitItemState.widget.element;

    int toIndex = animationElements.indexOf(element);
    int draggingIndex = animationElements.indexOf(dragging);
    bool isDraggingInSameRow = toIndex ~/ elementCountPerRow == draggingIndex ~/ elementCountPerRow;

    /// To lower index means user dragging to left, user dragging to left or top, the hit target should animate to right
    bool isDraggingToLowerIndex = toIndex < draggingIndex;
    int i = isDraggingToLowerIndex ? draggingIndex - 1 : draggingIndex + 1;
    for (; isDraggingToLowerIndex ? i >= toIndex : i <= toIndex; isDraggingToLowerIndex ? i-- : i++) {
      SortableElement e = animationElements[i];

      /// Swap the index in cached data
      int sourceIndex = i;
      int destinationIndex = isDraggingToLowerIndex ? i + 1 : i - 1;
      animationElements.swap(sourceIndex, destinationIndex);

      /// Handle animation by corresponding item's state
      SortableItemState itemState = e.state;
      itemState.sourceIndex = sourceIndex;
      itemState.destinationIndex = destinationIndex;
      itemState.startAnimation(isDraggingInSameRow);
    }

    /// Make sure you see the right thing on the right position
    setState(() {});
  }
}

/// Options for configuring the UI/Animation
class SortableWrapOptions {
  /// should long press and then become draggable
  bool isLongPressDraggable = false;

  Widget Function(Widget child)? draggableChildBuilder;

  /// the dragging moving view builder, typically return a widget wrap by [Material]
  Widget Function(Widget child) draggableFeedbackBuilder = (Widget child) {
    return Material(
      elevation: 18.0,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      borderRadius: BorderRadius.zero,
      child: child,
    );
  };

  SortableWrapOptions();

  /// clone a new instance
  SortableWrapOptions clone() {
    SortableWrapOptions newInstance = SortableWrapOptions();

    newInstance.draggableFeedbackBuilder = draggableFeedbackBuilder;

    return newInstance;
  }
}
