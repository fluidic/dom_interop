library dom_interop.js;

import 'dart:html';

import 'package:js/js.dart';

@JS('document.caretPositionFromPoint')
external JSCaretPosition jsCaretPositionFromPoint(int x, int y);

/// Represents the caret position, an indicator for the text insertion point.
@JS('CaretPosition')
class JSCaretPosition {
  external Node get offsetNode;
  external int get offset;
}

@JS('DOMInterop.hasCaretPositionFromPoint')
external bool hasCaretPositionFromPoint();

@JS('DOMInterop.hasCaretRangeFromPoint')
external bool hasCaretRangeFromPoint();
