library dom_interop;

import 'dart:html';

import 'package:range_fix/range_fix.dart';

import 'dom_interop_js.dart';

class CaretPosition {
  Node offsetNode;
  int offset;

  CaretPosition(this.offsetNode, this.offset);

  CaretPosition._(JSCaretPosition caretPosition)
      : offsetNode = caretPosition.offsetNode,
        offset = caretPosition.offset;
}

Iterable<Text> _iterateTextNodes(Node node) sync* {
  final walker = new TreeWalker(node, NodeFilter.SHOW_TEXT);

  var textNode;
  while ((textNode = walker.nextNode()) != null) {
    yield textNode;
  }
}

Range _rangeFromText(Text text, int startOffset, int endOffset) => new Range()
  ..setStart(text, startOffset)
  ..setEnd(text, endOffset);

bool _rangeContainsPoint(Range range, Point point) =>
    RangeFix.getClientRects(range).any((rect) => rect.containsPoint(point));

Point<int> _floorPoint(Point<num> point) =>
    new Point<int>(point.x.floor(), point.y.floor());

/// Retrieves the caret position in a document based on two coordinates.
/// A [_JSCaretPosition] is returned, containing the found DOM node and the
/// character offset in that node.
CaretPosition caretPositionFromPoint(Point<num> numPoint) {
  Point<int> point = _floorPoint(numPoint);

  // FIXME: Add support for IE
  if (hasCaretPositionFromPoint()) {
    return new CaretPosition._(jsCaretPositionFromPoint(point.x, point.y));
  } else if (hasCaretRangeFromPoint()) {
    // FIXME: Add a workaround for the bug.
    // https://code.google.com/p/chromium/issues/detail?id=400835
    final range = document.caretRangeFromPoint(point.x, point.y);
    return range == null
        ? null
        : new CaretPosition(range.startContainer, range.startOffset);
  } else {
    final element = document.elementFromPoint(point.x, point.y);
    final textNodes = _iterateTextNodes(element).toList();
    for (Text text in textNodes) {
      int min = 0;
      int max = text.length;
      while (min < max) {
        int mid = min + ((max - min) >> 1);
        final firstHalfRange = _rangeFromText(text, min, mid);
        final midRange = _rangeFromText(text, mid, mid + 1);
        final secondHalfRange = _rangeFromText(text, mid + 1, max);
        if (_rangeContainsPoint(midRange, point)) {
          return new CaretPosition(text, mid);
        } else if (_rangeContainsPoint(firstHalfRange, point)) {
          max = mid;
        } else if (_rangeContainsPoint(secondHalfRange, point)) {
          min = mid + 1;
        } else {
          break;
        }
      }
    }
    return null;
  }
}
