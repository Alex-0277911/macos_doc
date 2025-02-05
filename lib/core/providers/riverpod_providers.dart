import 'package:flutter/material.dart';
import 'package:macos_doc/widgets/my_sortable_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'riverpod_providers.g.dart';

@riverpod
class IsOutside extends _$IsOutside {
  @override
  bool build() {
    return false;
  }

  void update(bool isOutside) {
    state = isOutside;
  }
}

@riverpod
class HoveredIndex extends _$HoveredIndex {
  @override
  int? build() {
    return null;
  }

  void update(int? hoveredIndex) {
    if (state == hoveredIndex) {
      return;
    }
    state = hoveredIndex;
  }
}

@Riverpod(keepAlive: true)
class StartDragPosition extends _$StartDragPosition {
  @override
  Offset build() {
    return Offset.zero;
  }

  void update(Offset position) {
    if (state == position) {
      return;
    }
    state = position;
  }
}

@Riverpod(keepAlive: true)
class EndDragPosition extends _$EndDragPosition {
  @override
  Offset build() {
    return Offset.zero;
  }

  void update(Offset position) {
    if (state == position) {
      return;
    }
    state = position;
  }
}

@Riverpod(keepAlive: true)
class AnimationDragWidget extends _$AnimationDragWidget {
  @override
  bool build() {
    return false;
  }

  void update(bool animation) {
    if (state == animation) {
      return;
    }
    state = animation;
  }
}

@Riverpod(keepAlive: true)
class DraggingElement extends _$DraggingElement {
  @override
  SortableElement? build() {
    return null;
  }

  void update(SortableElement? element) {
    state = element;
  }
}
