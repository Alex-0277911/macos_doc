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

// @riverpod
// class DraggedIndex extends _$DraggedIndex {
//   @override
//   int? build() {
//     return null;
//   }
//
//   void update(int? draggedIndex) {
//     state = draggedIndex;
//   }
// }
//
// @riverpod
// class DirectionsMovement extends _$DirectionsMovement {
//   @override
//   Directions? build() {
//     return null;
//   }
//
//   void update(Directions? directions) {
//     // print('dragOffset => $dragOffset');
//     state = directions;
//   }
// }
//
// @riverpod
// class IsOutside extends _$IsOutside {
//   @override
//   bool build() {
//     return false;
//   }
//
//   void update(bool isOutside) {
//     // print('dragOffset => $dragOffset');
//     state = isOutside;
//   }
// }
//
// @riverpod
// class InsertIndex extends _$InsertIndex {
//   @override
//   int? build() {
//     return null;
//   }
//
//   void update(int? insertIndex) {
//     if (ref.read(isOutsideProvider)) {
//       print('insertIndex => null');
//       state = null;
//     } else {
//       print('insertIndex => $insertIndex');
//       state = insertIndex;
//     }
//   }
// }
//
// @riverpod
// class IsDragged extends _$IsDragged {
//   @override
//   bool build() {
//     return false;
//   }
//
//   void update(bool isDragged) {
//     print('isDragged => $isDragged');
//     state = isDragged;
//   }
// }
//
// // @riverpod
// // class ListOfDraggableGridItem extends _$ListOfDraggableGridItem {
// //   @override
// //   List<DraggableGridItem> build() {
// //     return [];
// //   }
// //
// //   void update(List<DraggableGridItem> listItems) {
// //     state = [...listItems];
// //   }
// //
// //   void clear() {
// //     state = [];
// //   }
// // }
// //
// // @riverpod
// // class SavedDraggableGridItem extends _$SavedDraggableGridItem {
// //   @override
// //   List<DraggableGridItem> build() {
// //     return [];
// //   }
// //
// //   void update(List<DraggableGridItem> listItems) {
// //     state = [...listItems];
// //   }
// //
// //   void clear() {
// //     state = [];
// //   }
// // }
// //
// // @riverpod
// // class HoveredIndex extends _$HoveredIndex {
// //   @override
// //   int build() {
// //     return -2;
// //   }
// //
// //   void update(int hoveredIndex) {
// //     state = hoveredIndex;
// //   }
// // }
// //
// // @riverpod
// // class IndexesItems extends _$IndexesItems {
// //   @override
// //   List<int> build() {
// //     return [];
// //   }
// //
// //   void update(List<int> indexes) {
// //     state = [...indexes];
// //   }
// // }
// //
// // @riverpod
// // class DraggingElement extends _$DraggingElement {
// //   @override
// //   (bool, int) build() {
// //     return (false, -1);
// //   }
// //
// //   void update(bool isDragging, int index) {
// //     state = (isDragging, index);
// //   }
// // }
// //
// // // @riverpod
// // // class IndexDraggingElement extends _$IndexDraggingElement {
// // //   @override
// // //   int build() {
// // //     return -1;
// // //   }
// // //
// // //   void update(int indexDraggingElement) {
// // //     print('UPDATE INDEX DRAGGING ELEMENT => $indexDraggingElement');
// // //     state = indexDraggingElement;
// // //   }
// // // }
// //
// // @riverpod
// // class OutsideZone extends _$OutsideZone {
// //   @override
// //   bool build() {
// //     return false;
// //   }
// //
// //   void update(bool isOutsideZone) {
// //     state = isOutsideZone;
// //   }
// // }
