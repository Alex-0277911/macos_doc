import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_doc/core/providers/riverpod_providers.dart';
import 'package:macos_doc/widgets/my_sortable_item.dart';
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
class _DockState<T> extends ConsumerState<Dock<T>> with TickerProviderStateMixin {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  final GlobalKey _myWidgetKey = GlobalKey();

  ///
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool visibleDraggedWidget = false;

  ///
  // Offset _offset = Offset.zero;
  // Duration _duration = Duration.zero;
  // Duration _duration = Duration(milliseconds: 300);

  // void _animatePosition(Offset position, Duration duration) {
  //   setState(() {
  //     _duration = duration;
  //     _offset = position;
  //   });
  //
  //   ///
  //   _controller.reset();
  //   _controller.forward();
  // }

  void _animatePositionDragged(Offset begin, Offset end) {
    setState(() {
      visibleDraggedWidget = true;
    });
    _controller.reset();
    final Offset endOffset = end - const Offset(24.0, 24.0);
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    final Tween<Offset> offsetTween = Tween<Offset>(
      begin: begin,
      end: endOffset,
    );
    _animation = offsetTween.animate(curvedAnimation);
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    final Tween<Offset> offsetTween = Tween<Offset>(
      begin: const Offset(-150, -150),
      end: const Offset(-100, -100),
    );

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation = offsetTween.animate(curvedAnimation);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          visibleDraggedWidget = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int? hoveredIndex = ref.watch(hoveredIndexProvider);
    final SortableElement? sortableElement = ref.watch(draggingElementProvider);
    final bool animationWidget = ref.watch(animationDragWidgetProvider);

    /// animation draggable widget to cancel dragging
    if (animationWidget) {
      _animatePositionDragged(ref.watch(endDragPositionProvider), ref.watch(startDragPositionProvider));
    }
    List<Widget> children = _items.map(widget.builder).toList();

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
    return Stack(
      children: [
        if (sortableElement != null)
          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return Positioned(
                left: _animation.value.dx,
                top: _animation.value.dy,
                child: Visibility(
                  visible: visibleDraggedWidget,
                  child: sortableElement.view,
                ),
              );
            },
          ),
        Container(
          alignment: Alignment.center,
          child: MouseRegion(
            onHover: (event) {
              final RenderBox box = _myWidgetKey.currentContext?.findRenderObject() as RenderBox;
              final Offset localPosition = box.globalToLocal(event.position);

              ///
              ref.read(startDragPositionProvider.notifier).update(event.position);

              ///
              final int hoveredIdx = ((localPosition.dx) / 66.0).floor().clamp(0, _items.length - 1);
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
              key: _myWidgetKey,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black12,
              ),
              padding: const EdgeInsets.all(4.0),
              child: SortableWrap(
                // onSortStart: (int index) {
                //   ref.read(sortStartedProvider.notifier).update(true);
                // },
                onSortCancel: (int index) async {
                  await Future.delayed(const Duration(milliseconds: 200));
                  ref.read(draggingElementProvider.notifier).update(null);
                },
                onSorted: (int oldIndex, int newIndex) {
                  // ref.read(draggingElementProvider.notifier).update(null);
                  // ref.read(sortStartedProvider.notifier).update(false);
                },
                options: options,
                children: children,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
