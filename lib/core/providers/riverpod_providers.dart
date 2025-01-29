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
