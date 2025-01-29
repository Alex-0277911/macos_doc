import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_doc/core/providers/riverpod_providers.dart';
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
class _DockState<T> extends ConsumerState<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    final int? hoveredIndex = ref.watch(hoveredIndexProvider);
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
    return MouseRegion(
      onHover: (event) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset localPosition = box.globalToLocal(event.position);
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.black12,
        ),
        padding: const EdgeInsets.all(4.0),
        child: SortableWrap(
          onSorted: (int oldIndex, int newIndex) {},
          options: options,
          children: children,
        ),
      ),
    );
  }
}
